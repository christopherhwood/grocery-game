//
//  EndGameView.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/9/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit
import SnapKit

protocol EndGameViewDelegate: AnyObject {
    func endGameView(_ view: EndGameView, pressedRestartButton button: UIButton)
}

class EndGameView: UIView {

    weak var delegate: EndGameViewDelegate?
    
    init(delegate: EndGameViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var numberCorrectLabel: UILabel = {
        var lbl = UILabel.titleLabel()
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var percentageCorrectLabel: UILabel = {
        var lbl = UILabel.titleLabel()
        lbl.textAlignment = .left
        return lbl
    }()
    
    var praise: String = "Good Job!" {
        didSet {
            DispatchQueue.main.async {
                self.titleLabel.text = "\(self.praise) \n\n Your results are below"
            }
        }
    }
    
    fileprivate
    func setupSubViews() {
        self.addSubview(titleLabel)
        self.addSubview(numberCorrectLabel)
        self.addSubview(percentageCorrectLabel)
        self.addSubview(restartButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Tools.safeAreaInsets.top + Tools.scaleY(30))
            make.left.equalToSuperview().offset(Tools.scaleX(20))
            make.right.equalToSuperview().offset(Tools.scaleX(-20))
        }
        
        numberCorrectLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(Tools.scaleY(40))
            make.left.right.equalTo(titleLabel)
        }
        
        percentageCorrectLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numberCorrectLabel.snp.bottom).offset(Tools.scaleY(10))
            make.left.right.equalTo(numberCorrectLabel)
        }
        
        restartButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-(Tools.safeAreaInsets.bottom + Tools.scaleY(30)))
            make.height.equalTo(40)
            make.width.equalTo(Tools.scaleX(145))
        }
    }
    
    lazy var titleLabel: UILabel = {
        var lbl = UILabel.titleLabel()
        lbl.text = "Good Job! \n\n Your results are below"
        return lbl
    }()
    
    lazy var restartButton: UIButton = {
        var btn = UIButton.submitButton()
        btn.setTitle("Try Again", for: .normal)
        btn.addTarget(self, action: #selector(restart(button:)), for: .touchUpInside)
        return btn
    }()
    
    @objc func restart(button: UIButton) {
        DispatchQueue.main.async {
            self.delegate?.endGameView(self, pressedRestartButton: button)
        }
    }

}
