//
//  ScoreController.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/8/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

class ScoreController {
    
    var answers: Array<CardAnswerModel> = []
    
    var numberCorrect: Int {
        get {
            return answers.filter{$0.card.correctImageUrl == $0.selectedAnswer}.count
        }
    }
    
    var percentCorrect: Double {
        get {
            let ratio = Double(numberCorrect)/Double(answers.count) * 100
            return Double(10 * ratio).rounded()/10
        }
    }
    
    func restart() {
        answers = []
    }
}
