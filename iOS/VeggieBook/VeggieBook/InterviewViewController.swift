//
//  InterviewViewController.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/16/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class InterviewViewController: UIViewController {
    var bookBuilder : BookBuilder?
    var interviewPageViewController : InterviewPageViewController? = nil
    var hud : MBProgressHUD = MBProgressHUD()
    
    @IBOutlet weak var bookImage: LargeBookHeadingView!
    
    // MARK: private methods
    
    private func setHeading(){
        let imageUrl = URL(string: (bookBuilder?.availableBook.largeUrl)!)
        bookImage.sd_setImage(with: imageUrl)
        bookImage.title = bookBuilder?.availableBook.title()
    }
    
    private func loadInterview(){
        var request = URLRequest(url: RestEndPoint.GetInterview.url!)
        let data = bookBuilder?.interviewRequest.data
        request.httpBody = data
        request.httpMethod = "POST"

//        print(UserDefaults.standard.integer(forKey: "profileId"))
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                print("error=\(String(describing: error))")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let interviewJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                self.bookBuilder?.initializeInterview(fromJson: interviewJson)
                DispatchQueue.main.async {
                    self.interviewPageViewController?.questionsReady()
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                print("\(data)")
                return
            }
        }
        task.resume()
    }
    
    private func loadSelections(){
        let url = RestEndPoint.GetSelectables.url!
        var request = URLRequest(url: url)
        let data = bookBuilder?.selectableRequest.data
        request.httpBody = data
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                print("error=\(String(describing: error))")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let selectablesJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [[String: Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                print("\(selectablesJson)")
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()

    }
    
    // MARK: overridden methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeading()
        navigationItem.titleView = UIImageView(image: Logo.getNegativeLogo())
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(InterviewViewController.goBack))
        navigationItem.leftBarButtonItem = backButton
        
        if(bookBuilder?.getInterview)!{
            loadInterview()
        }
        else {
            loadSelections()
        }
        
    }
    
    func goBack(){
        interviewPageViewController?.goToPreviousPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InterviewPageViewSegue" {
            interviewPageViewController = segue.destination as? InterviewPageViewController
            interviewPageViewController?.bookBuilder = bookBuilder
        }
        if segue.identifier == "interviewToFetching" {
            guard let fetchingVC = segue.destination as? FetchingViewController else {
                fatalError("Layout Error")
            }
            fetchingVC.bookBuilder = self.bookBuilder
        }
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
    }

}
