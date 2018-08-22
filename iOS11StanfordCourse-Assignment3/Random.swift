//
//  Random.swift
//  iOS11StanfordCourse-Assignment2
//
//  Created by Natxo Raga Llorens on 17/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import Foundation

// MARK: Int Extension

public extension Int {
    
    private static var random: Int {
        return Int.random(max: Int.max)
    }

    public static func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }

    public static func random(min: Int, max: Int) -> Int {
        return Int.random(max: max - min + 1) + min
    }
    
}


// MARK: Double Extension

extension Double {
    
    private static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    public static func random(max: Double) -> Double {
        return Double.random * max
    }
    
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
    
}
