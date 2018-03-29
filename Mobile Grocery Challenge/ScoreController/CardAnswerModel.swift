//
//  CardAnswerModel.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/8/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

struct CardAnswerModel {
    
    let card: CardModel!
    var selectedAnswer: String?
    var correct: Bool {
        get {
            return card.correctImageUrl == selectedAnswer
        }
    }
    
    init(card: CardModel, selectedAnswer: String?) {
        self.card = card
        self.selectedAnswer = selectedAnswer
    }
}
