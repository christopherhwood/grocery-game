//
//  PictureCollectionViewCell.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/8/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class PictureCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureForUrl(_ url: String) {
        imageView.kf.setImage(with: URL(string: url))
    }
    
    override var isSelected: Bool {
        didSet {
            DispatchQueue.main.async {
                if (self.isSelected) {
                    self.maskLayer.frame = self.imageView.bounds
                    self.imageView.layer.addSublayer(self.maskLayer)
                }
                else {
                    self.maskLayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    override func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        maskLayer.isHidden = true
    }
    
    class var size: CGSize {
        get {
            let h = Tools.scaleY(84)
            let w = Tools.scaleX(134)
            return CGSize(width: w, height: h)
        }
    }
    
    fileprivate
    lazy var imageView: UIImageView = {
        let imgView = UIImageView(frame: contentView.bounds)
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor.clear.cgColor
        imgView.backgroundColor = UIColor.lightGray
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    lazy var maskLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderColor = Tools.blue.cgColor
        layer.borderWidth = 2
        return layer;
    }()
}
