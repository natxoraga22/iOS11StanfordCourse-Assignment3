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
    var topLeft: CGPoint {
        get { return CGPoint(x: minX, y: minY) }
    }
    var topRight: CGPoint {
        get { return CGPoint(x: maxX, y: minY) }
    }
    var bottomLeft: CGPoint {
        get { return CGPoint(x: minX, y: maxY) }
    }
    var bottomRight: CGPoint {
        get { return CGPoint(x: maxX, y: maxY) }
    }
    var center: CGPoint {
        get { return CGPoint(x: midX, y: midY) }
    }
}
