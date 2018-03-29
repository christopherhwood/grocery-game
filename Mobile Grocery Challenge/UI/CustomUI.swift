//
//  CustomUI.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/8/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit

extension UILabel {
    class func titleLabel() -> UILabel {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .light)
        lbl.textColor = UIColor.black
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.textAlignment = .center
        return lbl
    }
}

extension UIButton {
    class func submitButton() -> UIButton {
        let btn = UIButton()
        btn.setTitleColor(Tools.blue , for: .normal)
        btn.setTitleColor(UIColor.white, for: .highlighted)
        btn.setBackgroundImage(nil, for: .normal)
        btn.setBackgroundImage(UIImage(named: "blue"), for: .highlighted)
        btn.layer.borderColor = Tools.blue.cgColor
        btn.layer.borderWidth = 2
        return btn
    }
}
