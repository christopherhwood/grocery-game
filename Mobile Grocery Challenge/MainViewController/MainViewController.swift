//
//  MainViewController.swift
//  Mobile Grocery Challenge
//
//  Created by Christopher Wood on 11/7/17.
//  Copyright © 2017 CW Apps. All rights reserved.
//

import UIKit
import Toaster
import Dispatch

class MainViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Tools.blue
        dataSource.requestData()
        setupSubViews()
    }

    deinit {
        timer?.setEventHandler {}
        timer?.cancel()
    }
    
    fileprivate
    lazy var timerLabel: UILabel = {
        var lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        lbl.textColor = UIColor(red: 223.0/255.0, green: 234.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        return lbl
    }()
    
    lazy var startGameView: StartGameView = {
        return StartGameView(delegate: self)
    }()
    
    lazy var endGameView: EndGameView = {
        return EndGameView(delegate: self)
    }()
    
    lazy var dataSource: CardDataSource = {
        return CardDataSource(delegate: self)
    }()
    
    lazy var cardCollectionView = { () -> UICollectionView in
        let collectionViewLayout = CardCollectionViewLayout(visibleCardCount: 3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.isScrollEnabled = false
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self.dataSource
        self.dataSource.registerViewsForCollectionView(collectionView)
        return collectionView
    }()
    
    lazy var scoreController: ScoreController = {
        return ScoreController()
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let gLayer = CAGradientLayer()
        gLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gLayer.locations = [NSNumber(value: 0.0), NSNumber(value: 1.0)]
        return gLayer
    }()
    
    var praise: String {
        get {
            if scoreController.percentCorrect == scoreController.percentCorrect, scoreController.percentCorrect > 50 {
                return "Good Job!"
            }
            else {
                return "You Can Do Better.."
            }
        }
    }
    
    var timer: DispatchSourceTimer?
    var time: Int = 0 {
        didSet {
            let min: Int = time/60
            let sec: Int = time - min*60
            var secStr = "\(sec)"
            while secStr.count < 2 {
                secStr.insert("0", at: secStr.startIndex)
            }
            timerLabel.text = "\(min) : \(secStr)"
        }
    }
    
    func setupSubViews() {
        
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
        view.addSubview(timerLabel)
        view.addSubview(endGameView)
        view.addSubview(cardCollectionView)
        view.addSubview(startGameView)
        
        timerLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Tools.safeAreaInsets.top + 15)
            make.centerX.equalToSuperview()
        }
        endGameView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Tools.scaleY(120))
            make.left.equalToSuperview().offset(Tools.scaleX(27))
            make.right.equalToSuperview().offset(Tools.scaleX(-27))
            make.bottom.equalToSuperview().offset(-(Tools.safeAreaInsets.bottom + 40))
        }
        cardCollectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Tools.scaleY(100))
            make.left.equalToSuperview().offset(Tools.scaleX(27))
            make.right.equalToSuperview().offset(Tools.scaleX(-27))
            make.bottom.equalToSuperview().offset(-(Tools.safeAreaInsets.bottom + 40))
        }
        startGameView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        cardCollectionView.isHidden = true
        timerLabel.isHidden = true
        endGameView.alpha = 0
    }
    
    func startTimer() {
        let queue = DispatchQueue.global(qos: .default)
        let timer = DispatchSource.makeTimerSource(queue: queue)
        timer.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(100))
        
        unowned let uself = self
        timer.setEventHandler {
            DispatchQueue.main.async {
                uself.time = uself.time - 1
                if uself.time <= 0 {
                    uself.timer?.cancel()
                    uself.gameEnded()
                }
            }
        }
        timer.resume()
        self.timer = timer
    }
    
    func startGame() {
        time = 120 // 60 seconds * 2 = 2 min
        startTimer()
        timerLabel.isHidden = false
        cardCollectionView.isHidden = false
    }
    
    func gameEnded() {
        timer?.cancel()
        cardCollectionView.isHidden = true
        
        if dataSource.items.count > 0 {
            let answerArr = dataSource.items.map({ (cardModel) -> CardAnswerModel in
                return CardAnswerModel(card: cardModel, selectedAnswer: nil)
            })
            scoreController.answers.append(contentsOf: answerArr)
        }
        
        endGameView.praise = praise
        endGameView.numberCorrectLabel.text = "Number Correct:  \(scoreController.numberCorrect)"
        let percent = scoreController.percentCorrect
        if (percent != percent || percent == 0) {
            endGameView.percentageCorrectLabel.text = String(format:"Percentage Correct: %.2f%%", 0.00)
        }
        else {
            endGameView.percentageCorrectLabel.text = String(format:"Percentage Correct: %.2f%%", percent)
        }
        
        weak var weakEndView = endGameView
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            weakEndView?.alpha = 1.0
        }, completion: nil)
    }
}

extension MainViewController: CardDataSourceDelegate {
    func dataSource(_ dataSource: CardDataSource, finishedLoadingWithError error: Error?) {
        if let error = error
        {
            Toast(text: error.localizedDescription).show()
        }
    }
    
    func dataSource(_ dataSource: CardDataSource, addChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: self)
        self.addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }
    
    func dataSource(_ dataSource: CardDataSource, answeredCard card: CardModel, withAnswer answer: String) {
        scoreController.answers.append(CardAnswerModel(card: card, selectedAnswer: answer))
    }
    
    func dataSourceNeedsReloadCollectionView(_ dataSource: CardDataSource) {
        cardCollectionView.reloadData()
    }
    
    func dataSource(_ dataSource: CardDataSource, didRemoveItemsAtIndexPaths indexPaths: [IndexPath]) {
        cardCollectionView.deleteItems(at: indexPaths)
        
        // check if game ended
        if (dataSource.items.count == 0) {
            gameEnded()
        }
    }
    
    func dataSource(_ dataSource: CardDataSource, batchUpdate update:(() -> Void), completion: ((Bool) -> Void)?) {
        cardCollectionView.performBatchUpdates(update, completion: completion)
    }
}

extension MainViewController: StartGameViewDelegate, EndGameViewDelegate {
    func startGameView(_ startView: StartGameView, pressedStartButton button: UIButton) {
        
        weak var weakStartView = startGameView
        unowned let uself = self
        UIView.animate(withDuration: 0.2, animations: {
            weakStartView?.alpha = 0
        }) { (_) in
            weakStartView?.removeFromSuperview()
            weakStartView = nil
            uself.startGame()
        }
    }
    
    func endGameView(_ view: EndGameView, pressedRestartButton button: UIButton) {
        dataSource.restart()
        scoreController.restart()
        
        weak var weakEndView = endGameView
        unowned let uself = self
        UIView.animate(withDuration: 0.2, animations: {
            weakEndView?.alpha = 0
        }) { (_) in
            uself.startGame()
        }
    }
}
