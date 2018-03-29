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
    
    override class var layoutAttributesClass: AnyClass {
        return CardCollectionViewLayoutAttributes.self
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            return collectionView?.bounds.size ?? .zero
        }
    }
    
    override func prepare() {

        for i in 0...visibleCardCount
        {
            let attributes = CardCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.frame = frameForIndex(i)
            attributes.zIndex = visibleCardCount - i
            attributes.transform3D = CATransform3DMakeTranslation(0, 0, CGFloat(visibleCardCount - i))
            attributes.backgroundColor = backgroundColorForIndex(i)
            layoutAttributes.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return Array(layoutAttributes[0..<min(visibleCardCount, cardDataSource?.items.count ?? 0)])
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> CardCollectionViewLayoutAttributes? {
        let attributes = layoutAttributes[indexPath.item]
        attributes.frame = frameForIndex(indexPath.item)
        attributes.zIndex = visibleCardCount - indexPath.item
        attributes.transform3D = CATransform3DMakeTranslation(0, 0, CGFloat(visibleCardCount - indexPath.item))
        attributes.backgroundColor = backgroundColorForIndex(indexPath.item)
        layoutAttributes.append(attributes)
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesForItem(at:itemIndexPath)
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
//        let idxPath = iOSBugFixIndexPath(itemIndexPath)
        
        let attributes = layoutAttributesForItem(at: itemIndexPath)
        
        if (itemIndexPath.item == 0 && attributes != nil)
        {
            let att = attributes!.copy() as! CardCollectionViewLayoutAttributes
            att.frame = CGRect(x: att.frame.origin.x, y: Tools.screenHeight, width: att.frame.width, height: att.frame.height)
            return att
        }
        
        return attributes
    }
    
    fileprivate
    var visibleCardCount: Int!
    lazy var layoutAttributes = [CardCollectionViewLayoutAttributes]()
    
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
    
//    func iOSBugFixIndexPath(_ indexPath: IndexPath) -> IndexPath {
//        guard let itemCount = cardDataSource?.items.count else {
//            return indexPath
//        }
//
//        if (itemCount == 2)
//        {
//            if (indexPath.item == 1)
//            {
//                return IndexPath(item: 2, section: indexPath.section)
//            }
//            else if (indexPath.item == 2)
//            {
//                return IndexPath(item: 1, section: indexPath.section)
//            }
//        }
//        else if (itemCount == 1)
//        {
//            if (indexPath.item == 0)
//            {
//                return IndexPath(item: 1, section: indexPath.section)
//            }
//            else
//            {
//                return IndexPath(item: 0, section: indexPath.section)
//            }
//        }
//        return indexPath
//    }
    
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
