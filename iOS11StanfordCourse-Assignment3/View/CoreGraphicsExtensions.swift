//
//  CoreGraphicsExtensions.swift
//  iOS11StanfordCourse-Assignment3
//
//  Created by Natxo Raga Llorens on 25/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import UIKit


extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    var topLeft: CGPoint { return CGPoint(x: minX, y: minY) }
    var topRight: CGPoint { return CGPoint(x: maxX, y: minY) }
    var bottomLeft: CGPoint { return CGPoint(x: minX, y: maxY) }
    var bottomRight: CGPoint { return CGPoint(x: maxX, y: maxY) }
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}
