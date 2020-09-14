//
//  LoginViewController.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/10/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var loginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = (Bundle.main.infoDictionary!["GOOGLE_CLIENT_ID"] as! String)
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self

        navigationItem.titleView = UIImageView(image: Logo.getNegativeLogo())
    }

    @IBAction func didTapSignOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
    }
    
    // [START signin_handler]
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
            // [START_EXCLUDE silent]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
            // [END_EXCLUDE]
        } else {
            // Perform any operations on signed in user here.
            guard let idToken = user.authentication.idToken, // Safe to send to the server
                let fullName = user.profile.name,
                let givenName = user.profile.givenName,
                let familyName = user.profile.familyName else {
                    fatalError("Failed to receive proper information from Google")
            }
            print(idToken)
            let registerRequest = RegisterRequest(token: idToken, firstName: givenName, lastName: familyName)
            vbSignIn(registerRequest: registerRequest){ profileId in
                guard let profileId = profileId else {
                    GIDSignIn.sharedInstance().signOut()
                    return
                }
                UserDefaults.standard.set(fullName, forKey: "fullName")
                UserDefaults.standard.set(profileId, forKey: "profileId")
                self.performSegue(withIdentifier: "unwindToMainView", sender: self)
            }
            
            // [START_EXCLUDE]
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ToggleAuthUINotification"),
                object: nil,
                userInfo: ["statusText": "Signed in user:\n\(String(describing: fullName))"])
            // [END_EXCLUDE]
        }
    }
    // [END signin_handler]
    // [START disconnect_handler]
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // [START_EXCLUDE]
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
    // [END disconnect_handler]
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func vbSignIn(registerRequest: RegisterRequest, completion: @escaping (Int?) -> Void){
        var request = URLRequest(url: RestEndPoint.Register.url!)
        let data = registerRequest.data
        request.httpBody = data
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-type")
        request.addValue("charset", forHTTPHeaderField: "utf-8")
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("error=\(String(describing: error))")
                completion(nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                print("error=\(String(describing: error))")
                completion(nil)
                return
            }
            
            do {
                guard let responseJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        completion(nil)
                        return
                }
                DispatchQueue.main.async {
                    print(responseJson)
                    guard let token = responseJson["profileId"] as? Int else {
                        completion(nil)
                        return
                    }
                    completion(token)
                }
            } catch  {
                print("error trying to convert data to JSON")
                print("\(data)")
                completion(nil)
                return
            }
        }
        task.resume()
    }

}
