//
//  BookBuilder.swift
//  VeggieBook
//
//  Created by Daniel DiPasquo on 1/15/17.
//  Copyright © 2017 DiPasquo Consulting. All rights reserved.
//

import Foundation

class BookBuilder {
    
    var availableBook : AvailableBook
    private var questions : [Question] = [] {
        didSet {
            // Don't add hidden questions as actual questions, but save off their attributes right away
            var temp_questions : [Question] = []
            for question in questions {
                if question.type == "H"{
                    for choice in question.choices{
                        baseAttributes.insert(choice.attribute)
                    }
                }
                else {
                    questionDict[question.identifier] = question
                    temp_questions.append(question)
                }
            }
            questions = temp_questions
        }
    }
    
    var selectables : [Selectable] = []
    var photos : [AvailablePhoto] = []
    private var selectableIndex : Int = -1
    
    private var questionDict : [String:Question] = [:]
    private var questionIndex : Int = -1
    
    private var baseAttributes = Set<String>()
    
    var attributeSet : Set<String> {
        get {
            var attributes = Set<String>(baseAttributes)
            for question in questions{
                for choice in question.choices{
                    if choice.response! {
                        attributes.insert(choice.attribute)
                    }
                }
            }
            return attributes
        }
    }
    
    var coverPhoto : Int = 0
    
    func getNextQuestion() -> Question? {
        questionIndex += 1
        if questionIndex >= questions.count {
            questionIndex = questions.count - 1
            return nil
        }
        return questions[questionIndex]
    }
    
    func getPreviousQuestion() -> Question? {
        questionIndex -= 1
        if questionIndex < 0 {
            questionIndex = 0
            return nil
        }
        return questions[questionIndex]
    }
    
    func getNextSelectable() -> Selectable? {
        selectableIndex += 1
        if selectableIndex >= selectables.count {
            selectableIndex = selectables.count - 1
            return nil
        }
        return selectables[selectableIndex]
    }
    
    func getPreviousSelectable() -> Selectable? {
        selectableIndex += 1
        if selectableIndex >= selectables.count {
            selectableIndex = selectables.count - 1
            return nil
        }
        return selectables[selectableIndex]
    }
    
    var getInterview : Bool {
        get {
            return self.availableBook.bookType == "RECIPE_BOOK"
        }
    }
    
    
    var interviewRequest : InterviewRequest {
        get {
            return InterviewRequest(bookType: availableBook.bookType, bookId: availableBook.id)
        }
    }
    
    var selectableRequest : SelectablesRequest {
        get {
            return SelectablesRequest(bookType: availableBook.bookType, bookId: availableBook.id, attributes: Array(attributeSet))
        }
    }
    
    var photosRequest : AvailablePhotosRequest {
        get {
            return AvailablePhotosRequest(bookId: availableBook.id)
        }
    }
    
    init(book:AvailableBook) {
        availableBook = book
    }
    
    func initializeInterview(fromJson: [String : Any]){
        let questionsList = fromJson["questions"] as! [[String : Any]]
        questions = Question.initQuestions(fromJson: questionsList)
    }
    
    func initalizeSelectables(fromJson:[[String: Any]]){
        selectables = Selectable.initSelectables(fromJson: fromJson)
    }
    
    func initalizePhotos(fromJson:[[String: Any]]){
        photos = AvailablePhoto.initFromJsonList(fromJson: fromJson)
    }
    
    func initializeSecretsPhotos(fromSelectables:[Selectable]){
        photos = AvailablePhoto.initFromSecretsSelectablesList(fromSelectables: fromSelectables)
    }
    
}
