//
//  SetGame.swift
//  iOS11StanfordCourse-Assignment2
//
//  Created by Natxo Raga Llorens on 17/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import Foundation


class SetGame {
    
    private static let numberOfStartingCards = 12
    
    // Cards
    private(set) var deck = [SetCard]()
    private(set) var dealtCards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    var selectedCardsMatch: Bool? {
        get {
            if selectedCards.count < 3 { return nil }
            else { return selectedCards[0].matchesWith(selectedCards[1], selectedCards[2]) }
        }
    }
    private(set) var matchedCards = [SetCard]()
    
    // Score
    private(set) var score = 0
    private static let matchScore = +5
    private static let mismatchScore = -3
    private static let deselectScore = -1
    private static let dealThreeCardsWithMatchOnTableScore = -2
    
    // AIPlayer
    private(set) lazy var aiPlayer = AIPlayer()
    private(set) var aiPlayerScore = 0
    var aiPlayerDelegate: AIPlayerDelegate?
    
    
    init() {
        // create a standard Set deck (one card for each combination)
        for number in SetCard.Number.allCases {
            for symbol in SetCard.Symbol.allCases {
                for shading in SetCard.Shading.allCases {
                    for color in SetCard.Color.allCases {
                        deck += [SetCard(number: number, symbol: symbol, shading: shading, color: color)]
                    }
                }
            }
        }
        // deal the starting cards
        for _ in 1...SetGame.numberOfStartingCards { dealtCards.append(getRandomCard()!) }
    }
    
    private func getRandomCard() -> SetCard? {
        return !deck.isEmpty ? deck.remove(at: Int.random(max: deck.count)) : nil
    }
    
    func dealThreeMoreCards() {
        precondition(deck.count >= 3, "Not enough cards in deck")
        if let match = selectedCardsMatch, match { replaceDealtSelectedCards() }
        else {
            if getMatchInDealtCards() != nil { score += SetGame.dealThreeCardsWithMatchOnTableScore }
            for _ in 1...3 { dealtCards.append(getRandomCard()!) }
        }
    }
    
    private func replaceDealtSelectedCards() {
        for selectedCard in selectedCards {
            if let randomCard = getRandomCard() { dealtCards[dealtCards.index(of: selectedCard)!] = randomCard }
        }
        selectedCards.removeAll()
    }
    
    func chooseCard(at index: Int) {
        // store chosen card
        let chosenCard: SetCard? = dealtCards.indices.contains(index) ? dealtCards[index] : nil
        
        // process previous match/mismatch
        if let previousMatch = selectedCardsMatch {
            if previousMatch {
                matchedCards.append(contentsOf: selectedCards)
                replaceDealtSelectedCards()
            }
            else { selectedCards.removeAll() }
        }
        
        if let card = chosenCard, !matchedCards.contains(dealtCards[index]) {
            // card already selected --> deselect
            if selectedCards.contains(card) {
                selectedCards.remove(at: selectedCards.index(of: card)!)
                score += SetGame.deselectScore
            }
            // card not selected and not changed (processing previous match can change the dealt cards) --> select
            else if dealtCards[index] == card { selectedCards += [card] }
            
            // Check match/mismatch
            if let newMatch = selectedCardsMatch {
                if newMatch {
                    score += SetGame.matchScore
                    aiPlayer.stopSearching()
                }
                else { score += SetGame.mismatchScore }
            }
            aiPlayer.searchMatch(onAlmostDone: aiPlayerAlmostDone, onSearchFinished: aiPlayerSearchFinished)
        }
    }
    
    func aiPlayerAlmostDone() {
        aiPlayerDelegate?.willFindMatch()
    }
    
    func aiPlayerSearchFinished() {
        if let matchCards = getMatchInDealtCards() {
            // AI player match
            if let previousMatch = selectedCardsMatch, previousMatch {
                matchedCards.append(contentsOf: selectedCards)
                replaceDealtSelectedCards()
            }
            selectedCards = matchCards
            matchedCards.append(contentsOf: selectedCards)
            replaceDealtSelectedCards()
            
            aiPlayerScore += SetGame.matchScore
        }
        else {
            aiPlayer.stopSearching()
        }
        aiPlayerDelegate?.didFindMatch()
    }
    
    func getMatchInDealtCards() -> [SetCard]? {
        let dealtCardsNotMatched = dealtCards.filter {
            if let match = selectedCardsMatch, match {
                if selectedCards.contains($0) { return false }
            }
            return !matchedCards.contains($0)
        }
        for index1 in 0..<dealtCardsNotMatched.count {
            for index2 in (index1 + 1)..<dealtCardsNotMatched.count {
                for index3 in (index2 + 1)..<dealtCardsNotMatched.count {
                    let card1 = dealtCardsNotMatched[index1]
                    let card2 = dealtCardsNotMatched[index2]
                    let card3 = dealtCardsNotMatched[index3]
                    if card1.matchesWith(card2, card3) { return [card1, card2, card3] }
                }
            }
        }
        return nil
    }
    
}
