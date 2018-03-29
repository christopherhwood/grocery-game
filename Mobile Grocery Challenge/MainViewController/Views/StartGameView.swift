//
//  StartGameView.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/8/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit
import SnapKit

protocol StartGameViewDelegate: AnyObject {
    func startGameView(_ view: StartGameView, pressedStartButton button: UIButton)
}

class StartGameView: UIView {
    
    weak var delegate: StartGameViewDelegate?

    init(delegate: StartGameViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate
    func setupSubViews() {
        self.addSubview(titleLabel)
        self.addSubview(instructionsLabel)
        self.addSubview(startButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Tools.safeAreaInsets.top + Tools.scaleY(30))
            make.left.equalToSuperview().offset(Tools.scaleX(20))
            make.right.equalToSuperview().offset(Tools.scaleX(-20))
        }
        
        instructionsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Tools.scaleY(50))
            make.left.right.equalTo(titleLabel)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(Tools.safeAreaInsets.bottom + Tools.scaleY(30)))
            make.height.equalTo(40)
            make.width.equalTo(Tools.scaleX(145))
        }
    }
    
    lazy var titleLabel: UILabel = {
        var lbl = UILabel.titleLabel()
        lbl.text = "Welcome \n\n Click 'Go' to Start"
        return lbl
    }()
    
    lazy var instructionsLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textColor = UIColor.black
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        lbl.text = "Select the picture that corresponds with the prompt.\nYou have two minutes to answer as many as you can.\n\n Good Luck!"
        return lbl
    }()
    
    lazy var startButton: UIButton = {
        var btn = UIButton.submitButton()
        btn.setTitle("GO", for: .normal)
        btn.addTarget(self, action: #selector(start(button:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func start(button: UIButton) {
        delegate?.startGameView(self, pressedStartButton: button)
    }
}
