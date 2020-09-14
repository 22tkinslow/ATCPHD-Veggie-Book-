//
//  RecipeViewController.swift
//  VeggieBook
//
//  Created by Matt Flickner on 6/26/17.
//  Copyright © 2017 Technical Empowerment Inc. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    var bookBuilder : BookBuilder?
    var selectablePageViewController : SelectablePageViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: bookBuilder?.availableBook.bookType == "RECIPE_BOOK" ?
            Logo.getNegativeLogo() : Logo.getSecretsLogo())
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(InterviewViewController.goBack))
        navigationItem.leftBarButtonItem = backButton
        loadSelections()

        // Do any additional setup after loading the view.
    }
    
    func goBack(){
        selectablePageViewController?.goToPreviousPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            do {
                guard let selectablesJson = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [[String: Any]] else {
                        print("error trying to convert data to JSON")
                        return
                }
                self.bookBuilder?.initalizeSelectables(fromJson: selectablesJson)
                DispatchQueue.main.async {
                    self.selectablePageViewController?.webPagesReady()
                }
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectablePageViewController = segue.destination as? SelectablePageViewController
        selectablePageViewController?.bookBuilder = bookBuilder
    }
}
