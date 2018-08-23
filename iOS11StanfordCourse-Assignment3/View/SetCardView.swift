//
//  SetCardView.swift
//  iOS11StanfordCourse-Assignment3
//
//  Created by Natxo Raga Llorens on 22/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import UIKit


@IBDesignable
class SetCardView: UIView {

    @IBInspectable var number: Int = 1 { didSet { setNeedsDisplay() } }
    var symbol: Symbol = .diamond { didSet { setNeedsDisplay() } }
    var shading: Shading = .solid { didSet { setNeedsDisplay() } }
    @IBInspectable var color: UIColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) { didSet { setNeedsDisplay() } }
    
    // Interface builder compatibility
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'symbol' instead.")
    @IBInspectable var symbolName: String? = "diamond" {
        willSet { if let newSymbol = Symbol(rawValue: newValue?.lowercased() ?? "") { symbol = newSymbol } }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'symbol' instead.")
    @IBInspectable var shadingName: String? = "solid" {
        willSet { if let newShading = Shading(rawValue: newValue?.lowercased() ?? "") { shading = newShading } }
    }
    

    override func draw(_ rect: CGRect) {
        // card
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        UIColor.white.setFill()
        roundedRect.fill()
        
        // symbols
        for index in 0..<number {
            let symbolPath = pathForSymbolInBounds(boundsForSymbolInPosition(index))
            switch shading {
                case .solid:
                    color.setFill()
                    symbolPath.fill()
                case .striped:
                    fallthrough
                case .open:
                    color.setStroke()
                    symbolPath.lineWidth = 5.0
                    symbolPath.stroke()
            }
        }
        
//        let firstOval = UIBezierPath(ovalIn: boundsForSymbolInPosition(0))
//        color.setFill()
//        firstOval.fill()
        
//        let secondItemBounds = CGRect(x: boundsWithMargin.origin.x, y: boundsWithMargin.origin.y + boundsWithMargin.height / 3.0,
//                                      width: boundsWithMargin.width, height: boundsWithMargin.height / 3.0)
//        let secondOval = UIBezierPath(ovalIn: secondItemBounds.insetBy(dx: 16.0, dy: 16.0))
//        color.setFill()
//        secondOval.fill()
//        
//        let thirdItemBounds = CGRect(x: boundsWithMargin.origin.x, y: boundsWithMargin.origin.y + (boundsWithMargin.height / 3.0) * 2.0,
//                                     width: boundsWithMargin.width, height: boundsWithMargin.height / 3.0)
//        let thirdOval = UIBezierPath(ovalIn: thirdItemBounds.insetBy(dx: 16.0, dy: 16.0))
//        color.setFill()
//        thirdOval.fill()
    }
    
    private func boundsForSymbolInPosition(_ position: Int) -> CGRect {
        var yPositionMultiplier: CGFloat = 0.0
        switch number {
            case 1: yPositionMultiplier = 1.0
            case 2: yPositionMultiplier = 0.5
            case 3: yPositionMultiplier = 0.0
            default: break
        }
        yPositionMultiplier += CGFloat(position)
        
        let boundsWithMargin = self.bounds.insetBy(dx: 32.0, dy: 32.0)
        let symbolHeight = boundsWithMargin.height / 3.0
        return CGRect(x: boundsWithMargin.origin.x, y: boundsWithMargin.origin.y + symbolHeight * yPositionMultiplier,
                      width: boundsWithMargin.width, height: symbolHeight).insetBy(dx: 16.0, dy: 16.0)
    }
    
    private func pathForSymbolInBounds(_ bounds: CGRect) -> UIBezierPath {
        switch symbol {
            case .diamond:
                let path = UIBezierPath()
                path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
                path.addLine(to: CGPoint(x: bounds.midX, y: bounds.minY))
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
                path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
                path.close()
                return path
            case .squiggle: return pathForSquiggleInBounds(bounds)
            case .oval: return UIBezierPath(ovalIn: bounds)
        }
    }
    
    private func pathForSquiggleInBounds(_ bounds: CGRect) -> UIBezierPath {
        // DEBUG: draw bounds
        let boundsPath = UIBezierPath(rect: bounds)
        UIColor.blue.setStroke()
        boundsPath.stroke()
        
        let path = UIBezierPath()
        
        let origin = CGPoint(x: bounds.minX, y: bounds.midY)
        path.move(to: origin)
        path.addCurve(to: CGPoint(x: bounds.maxX - bounds.width / 8.0, y: bounds.minY),
                      controlPoint1: CGPoint(x: bounds.minX + bounds.width / 4.0, y: bounds.minY - bounds.height / 2.0),
                      controlPoint2: CGPoint(x: bounds.minX + bounds.width / 2.0, y: bounds.minY + bounds.height / 2.0))
        //path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        
        path.addQuadCurve(to: CGPoint(x: bounds.maxX, y: bounds.midY),
                          controlPoint: CGPoint(x: bounds.maxX, y: bounds.minY))
        
        path.addCurve(to: CGPoint(x: bounds.minX + bounds.width / 8.0, y: bounds.maxY),
                      controlPoint1: CGPoint(x: bounds.maxX - bounds.width / 4.0, y: bounds.maxY + bounds.height / 2.0),
                      controlPoint2: CGPoint(x: bounds.maxX - bounds.width / 2.0, y: bounds.maxY - bounds.height / 2.0))
        
        path.addQuadCurve(to: origin, controlPoint: CGPoint(x: bounds.minX, y: bounds.maxY))
//        path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
//        path.addCurve(to: CGPoint(x: bounds.maxX, y: bounds.minY),
//                      controlPoint1: CGPoint(x: bounds.minX + bounds.width / 2.0, y: bounds.minY - bounds.height / 2.0),
//                      controlPoint2: CGPoint(x: bounds.minX + bounds.width / 2.0, y: bounds.minY + bounds.height / 2.0))
//        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
//        path.addCurve(to: CGPoint(x: bounds.minX, y: bounds.maxY),
//                      controlPoint1: CGPoint(x: bounds.maxX - bounds.width / 2.0, y: bounds.maxY + bounds.height / 2.0),
//                      controlPoint2: CGPoint(x: bounds.maxX - bounds.width / 2.0, y: bounds.maxY - bounds.height / 2.0))
        path.close()
        return path
    }
    
    
    // MARK: Enums
    
    enum Symbol: String {
        case diamond, squiggle, oval
    }
    
    enum Shading: String {
        case solid, striped, open
    }

}
