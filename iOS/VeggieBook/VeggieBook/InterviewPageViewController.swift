//
//  InterviewPageViewController.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/1/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//  Copyright © 2020 Quick Help For Meals, LLC. All rights reserved.
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

class InterviewPageViewController: UIPageViewController {
    
    var bookBuilder : BookBuilder? = nil
    
    
    func goToNextPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextQuestion = bookBuilder?.getNextQuestion() else {
            guard let interviewVC = self.parent as? InterviewViewController else {
                fatalError("Layout error")
            }
            interviewVC.bookBuilder = self.bookBuilder
            self.parent?.performSegue(withIdentifier: "interviewToFetching", sender: self.parent)
//            let fetchingVC = self.storyboard?.instantiateViewController(withIdentifier: "fetchingPage") as! FetchingViewController
//            fetchingVC.bookBuilder = bookBuilder
//            self.navigationController?.pushViewController(fetchingVC, animated: true)
            return
        }
        
        let controller = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        controller.question = nextQuestion
        controller.pageViewController = self
        setViewControllers([controller], direction: UIPageViewControllerNavigationDirection.forward, animated: true)
    }
    
    func goToPreviousPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let previousQuestion = bookBuilder?.getPreviousQuestion() else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let controller = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        controller.question = previousQuestion
        controller.pageViewController = self
        setViewControllers([controller], direction: UIPageViewControllerNavigationDirection.reverse, animated: true)

    }
    
    public func questionsReady() {
        goToNextPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check to see if the BookBuilder is ready and just start up if so.
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }


}
