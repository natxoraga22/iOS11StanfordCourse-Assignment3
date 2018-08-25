//
//  SetCard.swift
//  iOS11StanfordCourse-Assignment2
//
//  Created by Natxo Raga Llorens on 17/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import Foundation


struct SetCard: Equatable {
    
    let number: Number
    let symbol: Symbol
    let shading: Shading
    let color: Color
    
    func matchesWith(_ cardToMatch1: SetCard, _ cardToMatch2: SetCard) -> Bool {
        if self.number.matchesWith(cardToMatch1.number, cardToMatch2.number) {
            if self.symbol.matchesWith(cardToMatch1.symbol, cardToMatch2.symbol) {
                if self.shading.matchesWith(cardToMatch1.shading, cardToMatch2.shading) {
                    if self.color.matchesWith(cardToMatch1.color, cardToMatch2.color) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    // MARK: Enums
    
    enum Number: Int {
        case one = 1, two = 2, three = 3
        static var allCases: [Number] = [.one, .two, .three]
        
        func matchesWith(_ numberToMatch1: Number, _ numberToMatch2: Number) -> Bool {
            return (self == numberToMatch1 && self == numberToMatch2) || (self != numberToMatch1 && self != numberToMatch2 && numberToMatch1 != numberToMatch2)
        }
    }
    
    enum Symbol: Int {
        case symbol1, symbol2, symbol3
        static var allCases: [Symbol] = [.symbol1, .symbol2, .symbol3]
        
        func matchesWith(_ symbolToMatch1: Symbol, _ symbolToMatch2: Symbol) -> Bool {
            return (self == symbolToMatch1 && self == symbolToMatch2) || (self != symbolToMatch1 && self != symbolToMatch2 && symbolToMatch1 != symbolToMatch2)
        }
    }
    
    enum Shading: Int {
        case shading1, shading2, shading3
        static var allCases: [Shading] = [.shading1, .shading2, .shading3]
        
        func matchesWith(_ shadingToMatch1: Shading, _ shadingToMatch2: Shading) -> Bool {
            return (self == shadingToMatch1 && self == shadingToMatch2) || (self != shadingToMatch1 && self != shadingToMatch2 && shadingToMatch1 != shadingToMatch2)
        }
    }
    
    enum Color {
        case color1, color2, color3
        static var allCases: [Color] = [.color1, .color2, .color3]
        
        func matchesWith(_ colorToMatch1: Color, _ colorToMatch2: Color) -> Bool {
            return (self == colorToMatch1 && self == colorToMatch2) || (self != colorToMatch1 && self != colorToMatch2 && colorToMatch1 != colorToMatch2)
        }
    }
    
}
