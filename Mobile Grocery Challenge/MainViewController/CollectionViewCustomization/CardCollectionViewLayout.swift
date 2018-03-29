//
//  CardCollectionViewFlowLayout.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/7/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit

class CardCollectionViewLayout: UICollectionViewLayout {
    
    init(visibleCardCount: Int) {
        self.visibleCardCount = visibleCardCount
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return collectionView?.bounds.size ?? .zero
        }
    }
    
    override func prepare() {
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [CardCollectionViewLayoutAttributes]()
        
        let visibleIndexPaths = visibleIndexPathsInRect(rect)
        for indexPath in visibleIndexPaths {
            if let attributes = layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> CardCollectionViewLayoutAttributes? {
        let attributes = CardCollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frameForIndex(indexPath.item)
        attributes.backgroundColor = backgroundColorForIndex(indexPath.item)
        attributes.zIndex = visibleCardCount - indexPath.item
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = CardCollectionViewLayoutAttributes(forCellWith: itemIndexPath)
        
        attributes.frame = frameForIndex(itemIndexPath.item)
        attributes.frame = CGRect(x: attributes.frame.origin.x, y: Tools.screenHeight, width: attributes.frame.width, height: attributes.frame.height)
        return attributes
    }
    
    fileprivate
    var visibleCardCount: Int!
    
    func visibleIndexPathsInRect(_ rect: CGRect) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        var numberOfItemsInCollectionView = 0
        if let collectionView = collectionView {
            numberOfItemsInCollectionView = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) ?? 0
        }
        for i in 0..<min(visibleCardCount, numberOfItemsInCollectionView) {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        return indexPaths
    }
    
    func frameForIndex(_ index: Int) -> CGRect {
        let offsetMargin: CGFloat = 10
        let offset = Tools.scaleY(offsetMargin * CGFloat(index))
        let x: CGFloat = 0
        let y: CGFloat = Tools.scaleY(offsetMargin * CGFloat(visibleCardCount)) - offset
        var w: CGFloat = 0
        var h: CGFloat = 0
        
        if collectionView != nil {
            w = collectionView!.bounds.width
            h = collectionView!.bounds.height - (offsetMargin * CGFloat(visibleCardCount))
        }
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    func backgroundColorForIndex(_ index: Int) -> UIColor {
        switch index {
        case 0:
            return UIColor.white
        case 1:
            return UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 0.75)
        default:
            return UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 0.6)
        }
    }
    
    var cardDataSource: CardDataSource? {
        get {
            if let dataSource = collectionView?.dataSource as? CardDataSource {
                return dataSource
            }
            else {
                return nil
            }
        }
    }
}
