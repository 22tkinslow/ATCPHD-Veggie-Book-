//
//  Interview.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 2/24/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation

class Choice {
    var attribute : String
    var content : String
    var defaultChoice : Bool
    var response : Bool? = nil
    
    required init(attribute: String, content : String, defaultChoice : Bool) {
        self.attribute = attribute
        self.content = content
        self.defaultChoice = defaultChoice
    }
    
    required init(fromJson: [String:Any]){
        self.attribute = fromJson["attribute"] as! String
        self.content = fromJson["content"] as! String
        self.defaultChoice = fromJson["defaultChoice"] as! Bool
        self.response = fromJson["defaultChoice"] as? Bool
    }
    
    class func initChoices(fromJson:[[String:Any]]) -> [Choice]{
        var choices : [Choice] = []
        for json in fromJson{
            let choice = self.init(fromJson: json )
            choices.append(choice)
        }
        return choices
    }
}

class Question {
    
    var questionText : String
    var identifier : String
    var type : String
    var choices : [Choice] = []
    
    
    required init(identifier: String, type: String, questionText : String, choices: [Choice]) {
        self.identifier = identifier
        self.type = type
        self.questionText = questionText
        self.choices = choices
    }
    
    required init(fromJson:[String:Any]){
        self.identifier = fromJson["mnemonic"] as! String
        self.questionText = fromJson["intro"] as! String
        self.type = fromJson["qtype"] as! String
        let choices = fromJson["choices"] as! [[String:Any]]
        self.choices = Choice.initChoices(fromJson: choices)
    }
    
    class func initQuestions(fromJson: [[String:Any]]) -> [Question]{
        var questions : [Question] = []
        for json in fromJson{
            let question = self.init(fromJson: json)
            questions.append(question)
        }
        return questions
    }
    
}
