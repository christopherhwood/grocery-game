//
//  CardViewController.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/8/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit
import Toaster

protocol CardViewControllerDelegate: AnyObject {
    func viewController(_ viewController: CardViewController, submitAnswer answer: String, forCard card: CardModel)
}

class CardViewController: UIViewController {
    
    var card: CardModel? {
        didSet {
            DispatchQueue.main.async {
                if let card = self.card {
                    self.dataSource.items = card.imageUrls
                    self.titleLabel.text = card.title
                }
            }
        }
    }
    weak var delegate: CardViewControllerDelegate?
    
    init(delegate: CardViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.white
    }
    
    fileprivate
    lazy var dataSource: QuestionDataSource = {
        return QuestionDataSource(delegate: self)
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = .zero
        
        let itemW: CGFloat = view.bounds.size.width/2 - max(Tools.scaleX(30), 30) // max for iPhone5 - layout needs to be reworked
        let itemH: CGFloat = Tools.scaleY(150.0) // used below in collectionViewHeight calculation as well
        layout.itemSize = CGSize(width: itemW, height: itemH)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        dataSource.registerViewsForCollectionView(collectionView)
        return collectionView
    }()

    lazy var titleLabel: UILabel = {
        return UILabel.titleLabel()
    }()
    
    lazy var submitButton: UIButton = {
        let btn = UIButton.submitButton()
        btn.setTitle("Submit", for: .normal)
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return btn
    }()
    
    func setupSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(submitButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Tools.scaleY(30))
            make.left.equalToSuperview().offset(Tools.scaleX(20))
            make.right.equalToSuperview().offset(Tools.scaleX(-20))
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(Tools.scaleY(-20))
            make.height.equalTo(40)
            make.width.equalTo(Tools.scaleX(145))
        }
        
        collectionView.snp.makeConstraints { (make) in
            var bottomPadding = Tools.scaleY(-30)
            // iPhone 5
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    bottomPadding = -10
                default:
                    break
                }
            }
            make.bottom.equalTo(submitButton).offset(bottomPadding)
            make.left.right.equalToSuperview()
            make.height.equalTo(Tools.scaleY(150) * 2 + 50)
        }
    }
    
    @objc func submit() {
        guard let card = card else {
            return
        }
        guard let answer = dataSource.selectedItem else {
            Toast(text: "Please select an answer").show()
            return
        }
        
        dataSource.selectedItem = nil
        DispatchQueue.main.async {
            if answer == card.correctImageUrl {
                self.view.backgroundColor = UIColor.green
            }
            else {
                self.view.backgroundColor = UIColor.red
            }
            self.delegate?.viewController(self, submitAnswer: answer, forCard: card)
        }
    }
}

extension CardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.collectionView(collectionView, selectedItemAtIndexPath: indexPath)
    }
}

extension CardViewController: QuestionDataSourceDelegate {
    
    func dataSourceNeedsReloadCollectionView(_ dataSource: QuestionDataSource) {
        collectionView.reloadData()
    }
}
