//
//  CWError.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/7/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

class CWError: Error {
    enum api: Error {
        case fileNotFound
        case readingDataFailed
        case jsonParsingFailed
    }
}
