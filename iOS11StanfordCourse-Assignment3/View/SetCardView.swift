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
//        let boundsPath = UIBezierPath(rect: bounds)
//        UIColor.blue.setStroke()
//        boundsPath.stroke()
        
        let path = UIBezierPath()
        
        let limitSeparationX = bounds.width / 32.0
        let limitSeparationY = bounds.height / 32.0
        
        // ORIGIN
        let origin = CGPoint(x: bounds.minX + bounds.width / 16.0, y: bounds.minY + bounds.height / 4.0)
        path.move(to: origin)
        
        // FIRST CURVE
        let curve1ControlPoint1 = CGPoint(x: bounds.minX + bounds.width / 4.0, y: bounds.minY + bounds.height / 8.0 - bounds.height / 2.5)
        let curve1ControlPoint2 = CGPoint(x: bounds.minX + bounds.width * 0.5, y: bounds.minY + bounds.height * 0.5)
        drawPoint(curve1ControlPoint1, withColor: UIColor.blue)
        drawPoint(curve1ControlPoint2, withColor: UIColor.blue)
        path.addCurve(to: CGPoint(x: bounds.maxX - bounds.width / 6.5, y: bounds.minY + limitSeparationY * 2.0),
                      controlPoint1: curve1ControlPoint1,
                      controlPoint2: curve1ControlPoint2)
        
        
        path.addQuadCurve(to: CGPoint(x: bounds.maxX - limitSeparationX * 1.5, y: bounds.minY + limitSeparationY * 3.0),
                          controlPoint: CGPoint(x: bounds.maxX - bounds.width / 12, y: bounds.minY))

        
        // SECOND CURVE
        let curve2ControlPoint = CGPoint(x: bounds.maxX + limitSeparationX, y: bounds.minY + bounds.height * 0.3)
        drawPoint(curve2ControlPoint, withColor: UIColor.green)
        path.addQuadCurve(to: CGPoint(x: bounds.maxX - bounds.width / 16.0, y: bounds.maxY - bounds.size.height * 0.375),
                          controlPoint: curve2ControlPoint)
        
        
        // THIRD CURVE
        let curve3ControlPoint1 = CGPoint(x: bounds.maxX - bounds.width * 0.3, y: bounds.maxY - bounds.height / 8.0 + bounds.height / 2.5)
        let curve3ControlPoint2 = CGPoint(x: bounds.maxX - bounds.width * 0.5, y: bounds.maxY - bounds.height * 0.45)
        drawPoint(curve3ControlPoint1, withColor: UIColor.purple)
        drawPoint(curve3ControlPoint2, withColor: UIColor.purple)
        path.addCurve(to: CGPoint(x: bounds.minX + bounds.width / 6.0, y: bounds.maxY - limitSeparationY * 2.0),
                      controlPoint1: curve3ControlPoint1,
                      controlPoint2: curve3ControlPoint2)
        
        path.addQuadCurve(to: CGPoint(x: bounds.minX + bounds.width / 16.0, y: bounds.maxY - limitSeparationY * 3.0),
                          controlPoint: CGPoint(x: bounds.minX + bounds.width / 10, y: bounds.maxY))
        
        // FOURTH CURVE
        let curve4ControlPoint = CGPoint(x: bounds.minX - limitSeparationX, y: bounds.maxY - bounds.height * 0.375)
        drawPoint(curve4ControlPoint, withColor: UIColor.brown)
        path.addQuadCurve(to: origin, controlPoint: curve4ControlPoint)
        
        
        return path
    }
    
    // DEBUG
    private func drawPoint(_ point: CGPoint, withColor color: UIColor) {
//        let path = UIBezierPath(arcCenter: point, radius: 5, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
//        color.setFill()
//        path.fill()
    }
    
    
    // MARK: Enums
    
    enum Symbol: String {
        case diamond, squiggle, oval
    }
    
    enum Shading: String {
        case solid, striped, open
    }

}
