//
//  SetGame.swift
//  iOS11StanfordCourse-Assignment2
//
//  Created by Natxo Raga Llorens on 17/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import Foundation


class SetGame {
    
    // MARK: - Constants
    
    private struct Constants {
        static let numberOfStartingCards = 12
        static let matchScore = +5
        static let mismatchScore = -3
        static let deselectScore = -1
        static let dealThreeCardsWithMatchOnTableScore = -2
    }
    
    // MARK: - Card properties
    
    private(set) var deck = [SetCard]()
    private(set) var dealtCards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    
    var selectedCardsMatch: Bool? {
        if selectedCards.count < 3 { return nil }
        else { return selectedCards[0].matchesWith(selectedCards[1], selectedCards[2]) }
    }
    
    private var standardSetDeck: [SetCard] {
        var setDeck = [SetCard]()
        for number in SetCard.Number.allCases {
            for symbol in SetCard.Symbol.allCases {
                for shading in SetCard.Shading.allCases {
                    for color in SetCard.Color.allCases {
                        setDeck.append(SetCard(number: number, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
        return setDeck
    }
    
    private var matchableCards: [SetCard] {
        return dealtCards.filter {
            if let match = selectedCardsMatch, match { return !selectedCards.contains($0) }
            return true
        }
    }
    
    // MARK: - Score properties
    
    private(set) var score = 0
    
    // MARK: - AIPlayer properties
    
    private(set) var aiPlayer = AIPlayer()
    private(set) var aiPlayerScore = 0
    var aiPlayerDelegate: AIPlayerDelegate?
    
    
    // MARK: - Initializers
    
    init() {
        deck = standardSetDeck
        for _ in 1...Constants.numberOfStartingCards { dealtCards.append(drawRandomCardFromDeck()!) }
    }
    
    
    // MARK: - Public API
    
    func dealThreeMoreCards() {
        precondition(deck.count >= 3, "Not enough cards in deck")
        if let match = selectedCardsMatch, match { replaceMatchedCards() }
        else {
            if getMatchInDealtCards(usingSelectedCards: false) != nil { score += Constants.dealThreeCardsWithMatchOnTableScore }
            for _ in 1...3 { dealtCards.append(drawRandomCardFromDeck()!) }
        }
    }
    
    func chooseCard(at index: Int) {
        // store chosen card
        let chosenCard: SetCard? = dealtCards.indices.contains(index) ? dealtCards[index] : nil
        
        // process previous match/mismatch
        if let previousMatch = selectedCardsMatch {
            if previousMatch { replaceMatchedCards() }
            else { selectedCards.removeAll() }
        }
        
        if let card = chosenCard {
            // card already selected --> deselect
            if selectedCards.contains(card) {
                selectedCards.remove(at: selectedCards.index(of: card)!)
                score += Constants.deselectScore
            }
            // card not selected and not changed (processing previous match can change the dealt cards) --> select
            else if dealtCards[index] == card { selectedCards += [card] }
            
            // check match/mismatch
            if let newMatch = selectedCardsMatch {
                if newMatch {
                    score += Constants.matchScore
                    aiPlayer.stopSearching()
                }
                else { score += Constants.mismatchScore }
            }
            aiPlayer.searchMatch(onAlmostDone: aiPlayerAlmostDone, onSearchFinished: aiPlayerSearchFinished)
        }
    }
    
    func getMatchInDealtCards(usingSelectedCards useSelectedCards: Bool) -> [SetCard]? {
        let cardsToMatch = matchableCards
        if useSelectedCards && selectedCards.count == 2 {
            for index3 in 0..<cardsToMatch.count {
                if selectedCards[0].matchesWith(selectedCards[1], cardsToMatch[index3]) { return [selectedCards[0], selectedCards[1], cardsToMatch[index3]] }
            }
        }
        else if useSelectedCards && selectedCards.count == 1 {
            for index2 in 0..<cardsToMatch.count {
                for index3 in (index2 + 1)..<cardsToMatch.count {
                    if selectedCards[0].matchesWith(cardsToMatch[index2], cardsToMatch[index3]) { return [selectedCards[0], cardsToMatch[index2], cardsToMatch[index3]] }
                }
            }
        }
        else {
            for index1 in 0..<cardsToMatch.count {
                for index2 in (index1 + 1)..<cardsToMatch.count {
                    for index3 in (index2 + 1)..<cardsToMatch.count {
                        if cardsToMatch[index1].matchesWith(cardsToMatch[index2], cardsToMatch[index3]) { return [cardsToMatch[index1], cardsToMatch[index2], cardsToMatch[index3]] }
                    }
                }
            }
        }
        return nil
    }
    
    func reshuffleDealtCards() {
        dealtCards.shuffle()
    }
    
    
    // MARK: - Utility
    
    private func drawRandomCardFromDeck() -> SetCard? {
        return !deck.isEmpty ? deck.remove(at: Int.random(max: deck.count)) : nil
    }
    
    private func replaceMatchedCards() {
        precondition(selectedCardsMatch != nil && selectedCardsMatch!, "There is no matched cards")
        for selectedCard in selectedCards {
            // only replace if there is a card in the deck
            if let randomCard = drawRandomCardFromDeck() { dealtCards[dealtCards.index(of: selectedCard)!] = randomCard }
            else { dealtCards.remove(at: dealtCards.index(of: selectedCard)!) }
        }
        selectedCards.removeAll()
    }
    
    
    // MARK: - AIPlayer
    
    func aiPlayerAlmostDone() {
        aiPlayerDelegate?.aiPlayerWillFindMatch()
    }
    
    func aiPlayerSearchFinished() {
        if let matchCards = getMatchInDealtCards(usingSelectedCards: false) {
            // AI player match
            if let previousMatch = selectedCardsMatch, previousMatch { replaceMatchedCards() }
            selectedCards = matchCards
            replaceMatchedCards()
            
            aiPlayerScore += Constants.matchScore
        }
        else {
            aiPlayer.stopSearching()
        }
        aiPlayerDelegate?.aiPlayerDidFindMatch()
    }
    
}
