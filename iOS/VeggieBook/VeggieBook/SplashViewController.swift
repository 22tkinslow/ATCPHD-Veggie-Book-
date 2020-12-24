//
//  SplashViewController.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 12/15/16.
//  Copyright © 2016 DiPasquo Consulting. All rights reserved.
//  Copyright © 2020 Quick Help For Meals, LLC. All rights reserved.
//  Software developed at the University of Southern California.
//
//  This file is part of VeggieBook.
//
//  VeggieBook is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3 of the license only.
//
//  VeggieBook is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or fitness for a particular purpose. See the
//  GNU General Public License for more details.
//

import UIKit

class SplashViewController: UIViewController {

    let unexpectedErrorMessage = LanguageCode.appLanguage.isSpanish()
        ? "Ocurrió un error inesperado. Inténtalo más tarde."
        : "An unexpected error occurred. Try again later."
    let unableToConnectErrorMessage = LanguageCode.appLanguage.isSpanish()
        ? "No es posible conectarse al servidor. Inténtalo más tarde."
        : "Unable to connect to the server. Try again later.\n\n"
    var task: URLSessionDownloadTask!
    var session: URLSession!
    private var deviceId: String? { return UIDevice.current.identifierForVendor?.uuidString }
    private var userIsLoggedIn: Bool { return UserDefaults.standard.integer(forKey: "profileId") != 0 }

    enum ParsingErrors: Error {
        case invalidProfileId
    }

    enum TaskResult {
        case successfulData(Data)
        case successfulUrl(URL)
        case failure(Error, HTTPURLResponse)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //todo: swap logo if spanish
        
        //load libraryInfo and follow StartApp segue on completion
        session = URLSession.shared
        task = URLSessionDownloadTask()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performStartupTasks()
    }

    /**
     Perform all startup tasks and start the application upon their success.
    */
    private func performStartupTasks() {
        var userLoggedIn = self.userIsLoggedIn
        var libraryLoaded = false
        let dispatchGroup = DispatchGroup()
        if !userLoggedIn {
            // If there is an error during this login process, the application should not be started and an error
            // message will be displayed to the user.
            if let deviceId = self.deviceId {
                dispatchGroup.enter()
                loginOrCreateUserByDeviceId(deviceId: deviceId) { taskResult in
                    switch taskResult {
                    case .successfulData(let data):
                        userLoggedIn = self.saveProfileId(fromData: data)
                        break
                    case .failure(let error, let httpResponse):
                        self.displayFailedHttpRequestErrorMessage(error: error, response: httpResponse)
                        break
                    default:
                        break
                    }
                    dispatchGroup.leave()
                }
            } else {
                print("Error: Unable to load device ID. Login incomplete.")
            }
        }
        dispatchGroup.enter()
        loadLibraryInfo() { taskResult in
            switch taskResult {
            case .successfulUrl(let location):
                libraryLoaded = self.parseLibraryInfo(fromUrl: location)
                break
            case .failure(let error, let httpResponse):
                self.displayFailedHttpRequestErrorMessage(error: error, response: httpResponse)
                break
            default:
                break
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            if userLoggedIn && libraryLoaded {
                self.startApplication()
                return
            }
            self.alert(message: self.unexpectedErrorMessage)
        }
    }

    /**
     Using the device ID, send a request to the server to obtain the user ID for the associated device ID. The server
     will create a new user if one does not already exist.
        - parameter deviceId: The ID of the device being used to log a user in.
        - parameter completion: An action to be performed once the login request has responded. This should account for
                                both succesful and failing requests.
     */
    private func loginOrCreateUserByDeviceId(deviceId: String, completion: @escaping (TaskResult) -> Void) {
        // Previously, the user was logged in using a Google account but this simplified login approach makes the
        // Google login no longer necessary. However, it is still available but has been hidden from the user.
        var request = URLRequest(url: RestEndPoint.LoginByDeviceId.url!)
        request.httpBody = LoginByDeviceIdRequest(deviceId: deviceId).data
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(.failure(error, httpResponse))
            } else {
                completion(.successfulData(data!))
            }
        }
        task.resume()
    }

    /**
     Load library info.
        - parameter completion: An action to perform once the load library request has responded. This should account
                                for both successful and failing requests.
     */
    private func loadLibraryInfo(completion: @escaping (TaskResult) -> Void) {
        //todo: put urls in enum
        let url:URL! = RestEndPoint.LibraryInfo.url
        task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            if let error = error, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200, location == nil {
                completion(.failure(error, httpResponse))
            } else {
                completion(.successfulUrl(location!))
            }
        })
        task.resume()
    }

    /**
     Start the application by moving past the splash view. This should only be called when all essential startup tasks
     have completed.
     */
    private func startApplication() {
        self.performSegue(withIdentifier: "startApp", sender: nil)
    }

    /**
     Parse library info from a particular location.
        - parameter fromUrl: The URL to obtain the library info document from.
        - returns: True if the library info parsed properly, false otherwise.
     */
    private func parseLibraryInfo(fromUrl: URL?) -> Bool {
        guard let location = fromUrl, let data = try? Data(contentsOf: location) else {
            print("Error: Library info data unavailable.")
            return false;
        }
        do {
            let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String:Any]
            let _ = AvailableBook.parseLibraryObject(libraryObject: dic)
            print("Info: Library info soccessfully obtained.")
            return true
        } catch {
            print("Error: An unexpected error occurred while processing the HTTP response.")
            self.alert(message: self.unableToConnectErrorMessage)
        }
        return false
    }

    /**
     Save the user ID from a data object.
        - parameter fromData: The data that is returned from `loginOrCreateUserByDeviceId`.
        - returns: True if the profile ID saved properly, false otherwise.
     */
    private func saveProfileId(fromData: Data) -> Bool {
        do {
            let profileId = try self.getProfileId(fromData: fromData)
            UserDefaults.standard.set(profileId, forKey: "profileId")
            print("Info: User successfully logged in.")
            return true
        } catch {
            print("Error: An unexpected error occurred while processing the HTTP response.")
            self.alert(message: self.unexpectedErrorMessage)
        }
        return false
    }

    /**
     Get the user's profile ID from the data response for logging in with a device ID.
     */
    private func getProfileId(fromData: Data) throws -> Int {
        guard let responseJson = try? JSONSerialization.jsonObject(with: fromData, options: []) as? [String: Any],
            let profileId = responseJson?["profileId"] as? Int else {
                print("Error: Couldn't parse JSON due to unexpected format.")
                throw ParsingErrors.invalidProfileId
        }
        return profileId

    }

    /**
     Display the appropriate error message based on the server response.
        - parameter error: An error returned when attempting to log the user into the application.
        - parameter response: The response returned when attempting to log the user into the application.
     */
    private func displayFailedHttpRequestErrorMessage(error: Error?, response: HTTPURLResponse?) {
        self.alert(message: self.unableToConnectErrorMessage)

        print("Error: Something went wrong during the applicaiton startup tasks.\n")
        if let httpStatus = response, httpStatus.statusCode != 200 {
            print("HTTP status code should be 200, but is \(httpStatus.statusCode)\n"
                + "response=\(String(describing: response))\n")
        }
        if let error = error {
            print("error=\(String(describing: error))")
        }
    }
}

