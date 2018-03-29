//
//  Tools.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/7/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit

class Tools {
    
    // MARK: Sizing
    class var standardWidth: CGFloat {
        get {
            return isPortrait ? 375 : 667
        }
    }
    
    class var standardHeight: CGFloat {
        get {
            return isPortrait ? 667 : 375
        }
    }
    
    class var isPortrait: Bool {
        get {
            return UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height
        }
    }
    
    class var safeAreaInsets: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
            } else {
                return UIEdgeInsets.zero
            }
        }
    }
    
    class var safeAreaRect: CGRect {
        get {
            let width = screenWidth - safeAreaInsets.left - safeAreaInsets.right
            let height = screenHeight - safeAreaInsets.top - safeAreaInsets.bottom
            return CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: width, height: height)
        }
    }
    
    class var screenWidth: CGFloat {
        get {
            if isPortrait {
                return UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale
            }
            else {
                return UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale
            }
        }
    }
    
    class var screenHeight: CGFloat {
        get {
            if isPortrait {
                return UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale
            }
            else {
                return UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale
            }
        }
    }
    
    class func scaleX(_ x: CGFloat) -> CGFloat {
        return floor(x * safeAreaRect.width / standardWidth)
    }
    
    class func scaleY(_ y: CGFloat) -> CGFloat {
        return floor(y * safeAreaRect.height / standardHeight)
    }
    
    // MARK: Colors
    static let blue: UIColor = UIColor(red: 52.0/255.0, green: 147.0/255.0, blue: 136.0/255.0, alpha: 1.0)
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
