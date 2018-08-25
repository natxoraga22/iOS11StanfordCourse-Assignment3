//
//  SetViewController.swift
//  iOS11StanfordCourse-Assignment2
//
//  Created by Natxo Raga Llorens on 17/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import UIKit


class SetViewController: UIViewController, AIPlayerDelegate {
    
    // MARK: - Model
    
    private var game: SetGame! {
        didSet {
            game.aiPlayerDelegate = self
            updateViewFromModel()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var dealMoreCardsButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var aiPlayerScoreLabel: UILabel!
    
    @IBOutlet private weak var cardsGrid: SetCardsGrid! {
        didSet {
            cardsGrid.cardsTapGestureRecognizerTarget = self
            cardsGrid.cardsTapGestureRecognizerAction = #selector(tapCard(_:))
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownToDealThreeMoreCards(_:)))
            swipe.direction = .down
            cardsGrid.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateToShuffleDealtCards(_:)))
            cardsGrid.addGestureRecognizer(rotate)
        }
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = SetGame()
    }
    
    // MARK: - IBActions
    
    @IBAction private func touchNewGame() {
        game = SetGame()
    }
    
    @IBAction private func touchDealThreeMoreCards() {
        game.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    @objc private func swipeDownToDealThreeMoreCards(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            if game.deck.count >= 3 {
                game.dealThreeMoreCards()
                updateViewFromModel()
            }
        }
    }
    
    @objc private func tapCard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let cardIndex = cardsGrid.cardViews.index(of: sender.view as! SetCardView)
            game.chooseCard(at: cardIndex!)
            updateViewFromModel()
        }
    }
    
    @objc private func rotateToShuffleDealtCards(_ sender: UIRotationGestureRecognizer) {
        // TODO: IMPLEMENT
    }
    
    @IBAction private func touchCheat() {
        if let matchCards = game.getMatchInDealtCards() {
            for matchCard in matchCards {
                let cardView = cardsGrid.cardViews[game.dealtCards.index(of: matchCard)!]
                cardView.layer.borderWidth = 3.0
                cardView.layer.borderColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
            }
        }
    }
    
    // MARK: - Model-View synchronization
    
    private func updateViewFromModel() {
        // card views
        cardsGrid.cardViews.removeAll()
        for card in game.dealtCards {
            
            // card content
            let cardView = SetCardView(frame: CGRect.zero)
            cardView.number = card.number.rawValue
            cardView.symbol = SetCardView.Symbol(rawValue: card.symbol.rawValue)!
            cardView.shading = SetCardView.Shading(rawValue: card.shading.rawValue)!
            cardView.color = getCardViewColorFromCardColor(card.color)
            
            // card state
            if game.selectedCards.contains(card) {
                if let cardMatched = game.selectedCardsMatch {
                    if cardMatched { cardView.state = .matched }
                    else { cardView.state = .mismatched}
                } else { cardView.state = .selected }
            } else { cardView.state = .none }
            
            cardsGrid.cardViews.append(cardView)
        }
        
        // enable/disable deal more cards button
        dealMoreCardsButton.isEnabled = game.deck.count >= 3
        
        // scores
        scoreLabel.text = "🏆 \(game.score)"
        aiPlayerScoreLabel.text = getAIPlayerEmoji() + " \(game.aiPlayerScore)"
    }
    
    private func getCardViewColorFromCardColor(_ cardColor: SetCard.Color) -> UIColor {
        switch cardColor {
            case .color1: return UIColor.red
            case .color2: return UIColor.green
            case .color3: return UIColor.purple
        }
    }
    
    private func getAIPlayerEmoji() -> String {
        switch game.aiPlayer.status {
            case .idle: return "😴"
            case .thinking: return "🤔"
            case .almostDone: return "😁"
            case .matchFound: return "😂"
            case .matchLost: return "😢"
        }
    }
    
    // MARK: - AIPlayerDelegate
    
    func aiPlayerWillFindMatch() {
        updateViewFromModel()
    }
    
    func aiPlayerDidFindMatch() {
        updateViewFromModel()
    }

}
