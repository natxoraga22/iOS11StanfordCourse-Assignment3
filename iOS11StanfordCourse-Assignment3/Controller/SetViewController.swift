//
//  SetViewController.swift
//  iOS11StanfordCourse-Assignment2
//
//  Created by Natxo Raga Llorens on 17/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import UIKit


class SetViewController: UIViewController, AIPlayerDelegate {
    
    // Model
    private var game: SetGame! {
        didSet {
            game.aiPlayerDelegate = self
            updateViewFromModel()
        }
    }
    
    @IBOutlet private weak var dealMoreCardsButton: UIButton!
    @IBOutlet private weak var cardsGrid: SetCardsGrid!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var aiPlayerScoreLabel: UILabel!
    //private var cardButtons = [SetCardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game = SetGame()
    }
    
    @IBAction private func touchNewGame() {
        game = SetGame()
    }
    
    @IBAction private func touchDealThreeMoreCards() {
        game.dealThreeMoreCards()
        updateViewFromModel()
    }
    
//    @IBAction private func touchCard(_ sender: UIButton) {
//        game.chooseCard(at: cardButtons.index(of: sender)!)
//        updateViewFromModel()
//    }
    
    @IBAction private func touchCheat() {
        if let matchCards = game.getMatchInDealtCards() {
            for matchCard in matchCards {
                let cardView = cardsGrid.cardViews[game.dealtCards.index(of: matchCard)!]
                cardView.layer.borderWidth = 3.0
                cardView.layer.borderColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
            }
        }
    }
    
    func willFindMatch() {
        updateViewFromModel()
    }
    
    func didFindMatch() {
        updateViewFromModel()
    }
    
    private func getCardViewSymbolFromCardSymbol(_ cardSymbol: SetCard.Symbol) -> SetCardView.Symbol {
        switch cardSymbol {
            case .symbol1: return SetCardView.Symbol.diamond
            case .symbol2: return SetCardView.Symbol.oval
            case .symbol3: return SetCardView.Symbol.squiggle
        }
    }
    
    private func getCardViewShadingFromCardShading(_ cardShading: SetCard.Shading) -> SetCardView.Shading {
        switch cardShading {
            case .shading1: return SetCardView.Shading.open
            case .shading2: return SetCardView.Shading.solid
            case .shading3: return SetCardView.Shading.striped
        }
    }
    
    private func getCardViewColorFromCardColor(_ cardColor: SetCard.Color) -> UIColor {
        switch cardColor {
            case .color1: return UIColor.red
            case .color2: return UIColor.green
            case .color3: return UIColor.purple
        }
    }
    
    private func updateViewFromModel() {
        // card views
        cardsGrid.cardViews.removeAll()
        for card in game.dealtCards {
            let cardView = SetCardView(frame: CGRect.zero)
            cardView.number = card.number.rawValue
            cardView.symbol = getCardViewSymbolFromCardSymbol(card.symbol)
            cardView.shading = getCardViewShadingFromCardShading(card.shading)
            cardView.color = getCardViewColorFromCardColor(card.color)
            cardsGrid.cardViews.append(cardView)
        }
        
        // enable/disable deal more cards button
        dealMoreCardsButton.isEnabled = game.deck.count >= 3
        
        // scores
        scoreLabel.text = "🏆 \(game.score)"
        aiPlayerScoreLabel.text = getAIPlayerEmoji() + " \(game.aiPlayerScore)"

        
//        // card buttons
//        for (index, cardView) in setCardGrid.setCardViews.enumerated() {
//            if index < game.dealtCards.count {
//                let dealtCard = game.dealtCards[index]
//                // matched card (for end game cases)
//                if game.matchedCards.contains(dealtCard) { hideCardButton(cardView) }
//                else {
//                    updateCardButtonContent(cardView, fromCard:dealtCard)
//
//                    // selected card (can be matched, mismatched or simply selected)
//                    if game.selectedCards.contains(dealtCard) {
//                        cardView.layer.borderWidth = 3.0
//                        if let cardMatched = game.selectedCardsMatch {
//                            if cardMatched { cardView.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1) }
//                            else { cardView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) }
//                        }
//                        else { cardView.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1) }
//                    }
//                    // not selected card
//                    else { cardView.layer.borderWidth = 0.0 }
//                }
//            }
//            // card not dealt
//            else { hideCardButton(cardView) }
//        }
        
//
    }
    
//    private func hideCardView(_ cardView: UIButton) {
//        cardButton.setTitle(nil, for: UIControlState.normal)
//        cardButton.setAttributedTitle(nil, for: UIControlState.normal)
//        cardButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//        cardButton.layer.borderWidth = 0.0
//    }
    
    
    private func getAIPlayerEmoji() -> String {
        switch game.aiPlayer.status {
            case .idle: return "😴"
            case .thinking: return "🤔"
            case .almostDone: return "😁"
            case .matchFound: return "😂"
            case .matchLost: return "😢"
        }
    }

}
