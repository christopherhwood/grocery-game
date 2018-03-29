//
//  QuestionDataSource.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/8/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit

protocol QuestionDataSourceDelegate: AnyObject {
    func dataSourceNeedsReloadCollectionView(_ dataSource: QuestionDataSource)
}

class QuestionDataSource: NSObject, UICollectionViewDataSource {
    
    var items: Array<String> = [] {
        didSet {
            notifyNeedsReloadCollectionView()
        }
    }
    var selectedItem: String?
    weak var delegate: QuestionDataSourceDelegate?
    
    init(delegate: QuestionDataSourceDelegate) {
        self.delegate = delegate
    }
    
    func registerViewsForCollectionView(_ collectionView: UICollectionView) {
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: String(describing:PictureCollectionViewCell.self))
    }
    
    func collectionView(_ collectionView: UICollectionView, selectedItemAtIndexPath indexPath: IndexPath) {
    
        selectedItem = items[indexPath.item]
    }
    
    // MARK: CollectionView Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PictureCollectionViewCell.self), for: indexPath) as? PictureCollectionViewCell else {
            fatalError("Could not dequeue cell")
        }
        
        cell.configureForUrl(items[indexPath.item])
        return cell
    }
    
    fileprivate
    func notifyNeedsReloadCollectionView() {
        DispatchQueue.main.async {
            self.delegate?.dataSourceNeedsReloadCollectionView(self)
        }
    }
}
