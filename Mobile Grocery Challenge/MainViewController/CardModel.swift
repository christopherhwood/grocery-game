//
//  CWCardModel.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/7/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

struct CardModel: Equatable {
    let ID: Int!
    let title: String!
    let imageUrls: [String]!
    let correctImageUrl: String!
    
    static func ==(lhs: CardModel, rhs: CardModel) -> Bool {
        return lhs.ID == rhs.ID
    }
}
