//
//  CardJSONReader.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/7/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import Foundation
import SwiftyJSON

class CardJSONReader {
    
    class func requestCardDataWithSuccessHandler(_ successHandler:(_ cardArray: [CardModel]) -> Void, failHandler:(_ error: Error) -> Void) {
        guard let path = Bundle.main.url(forResource: "zquestions", withExtension: "json") else {
            failHandler(CWError.api.fileNotFound)
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: path, options: .mappedIfSafe)
            guard let jsonDict = JSON(data: jsonData).dictionary else {
                failHandler(CWError.api.jsonParsingFailed)
                return
            }
            
            var cardArray = [CardModel]()
            for (offset: i,element: (key: title, value: urlJSON)) in jsonDict.enumerated() {
                
                guard let urlArr = urlJSON.arrayObject as? [String], urlArr.count == 4, title.count > 0 else {
                    continue
                }
                
                let card = CardModel(ID: i, title: title, imageUrls: urlArr, correctImageUrl: urlArr[0])
                cardArray.append(card)
            }
            successHandler(cardArray)
        }
        catch {
            failHandler(CWError.api.readingDataFailed)
            return
        }
    }
}
