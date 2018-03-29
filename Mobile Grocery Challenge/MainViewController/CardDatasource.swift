//
//  CardDatasource.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/7/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit

protocol CardDataSourceDelegate: AnyObject {
    func dataSource(_ dataSource: CardDataSource, finishedLoadingWithError error:Error?)
    func dataSource(_ dataSource: CardDataSource, addChildViewController viewController: UIViewController)
    func dataSource(_ dataSource: CardDataSource, answeredCard card: CardModel, withAnswer answer: String)
    
    func dataSourceNeedsReloadCollectionView(_ dataSource: CardDataSource)
    func dataSource(_ dataSource: CardDataSource, batchUpdate update:(() -> (Void)), completion: ((Bool) -> (Void))?)
    func dataSource(_ dataSource: CardDataSource, didRemoveItemsAtIndexPaths indexPaths: [IndexPath])
}

class CardDataSource: NSObject, UICollectionViewDataSource {
    
    var items: Array<CardModel> = [] {
        didSet {
            notifyNeedsReloadCollectionView()
        }
    }
    weak var delegate: CardDataSourceDelegate?
    
    init(delegate: CardDataSourceDelegate?) {
        self.delegate = delegate
    }
    
    func registerViewsForCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CardCollectionViewCell.self))
    }
    
    func requestData() {
        unowned let uself = self
        CardJSONReader.requestCardDataWithSuccessHandler({ (cardArray) in
            uself.items = cardArray
            shuffleCards()
            uself.delegate?.dataSource(uself, finishedLoadingWithError: nil)
        }) { (err) in
            uself.delegate?.dataSource(uself, finishedLoadingWithError: err)
        }
    }
    
    func restart() {
        items.append(contentsOf: usedCards)
        usedCards.removeAll()
        shuffleCards()
    }
    
    // MARK: CollecitonView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardCollectionViewCell.self), for: indexPath) as? CardCollectionViewCell else {
            fatalError("CollectionView did not return proper cell from dequeReusableCell")
        }
        
        let vc = recycledOrNewViewController()
        vc.card = items[indexPath.item]
        viewControllersByIndexPath[indexPath] = vc
        cell.configureWithView(vc.view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: IndexPath) {
        guard let vc = viewControllersByIndexPath[indexPath] else {
            fatalError("No ViewController registered for indexpath")
        }
        viewControllersByIndexPath.removeValue(forKey: indexPath)
        unusedViewControllers.insert(vc)
    }
    
    // MARK: Private
    fileprivate
    var usedCards: Array<CardModel> = []
    lazy var unusedViewControllers: Set<CardViewController> = []
    lazy var viewControllersByIndexPath: Dictionary<IndexPath, CardViewController> = [:]
    
    func recycledOrNewViewController() -> CardViewController {
        if unusedViewControllers.count > 1, let vc = unusedViewControllers.first {
            unusedViewControllers.remove(vc)
            return vc
        }
        let vc = CardViewController(delegate: self)
        self.delegate?.dataSource(self, addChildViewController: vc)
        return vc
    }
    
    func notifyItemsRemovedAtIndexPaths(_ removedIndexPaths:[IndexPath]) {
        
        DispatchQueue.main.async {
            self.delegate?.dataSource(self, batchUpdate: {
                
                for indexPath in removedIndexPaths {
                    self.items.remove(at: indexPath.item)
                }
                self.delegate?.dataSource(self, didRemoveItemsAtIndexPaths: removedIndexPaths)
            }, completion: nil)
            
        }
    }
    
    func notifyNeedsReloadCollectionView() {
        DispatchQueue.main.async {
            self.delegate?.dataSourceNeedsReloadCollectionView(self)
        }
    }
    
    func shuffleCards() {
        // shuffle image order
        for i in 0..<items.count {
            let card = items[i]
            var urlArr: Array<String> = card.imageUrls
            urlArr.shuffle()
            items[i] = CardModel(ID: card.ID, title: card.title, imageUrls: urlArr, correctImageUrl: card.correctImageUrl)
        }
        // shuffle card order
        items.shuffle()
    }
}

// MARK: CardViewController Delegate
extension CardDataSource: CardViewControllerDelegate {
    
    func viewController(_ viewController: CardViewController, submitAnswer answer: String, forCard card: CardModel) {
        delegate?.dataSource(self, answeredCard: card, withAnswer: answer)
        usedCards.append(card)
        
        let indexPath = IndexPath(item: 0, section: 0)
        notifyItemsRemovedAtIndexPaths([indexPath])
    }
}
