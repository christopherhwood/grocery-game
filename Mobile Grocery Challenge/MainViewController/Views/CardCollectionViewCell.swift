//
//  CardCollectionViewCell.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/8/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit
import SnapKit

class CardCollectionViewCell: UICollectionViewCell {
    
    var hostedView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWithView(_ view: UIView) {
        hostedView = view
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
}
