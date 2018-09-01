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

    // MARK: - Properties
    
    @IBInspectable var number: Int = 1 { didSet { setNeedsDisplay() } }
    var symbol: Symbol = .diamond { didSet { setNeedsDisplay() } }
    var shading: Shading = .solid { didSet { setNeedsDisplay() } }
    @IBInspectable var color: UIColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) { didSet { setNeedsDisplay() } }
    
    var state: State = .none { didSet { setNeedsDisplay() } }
    
    // Interface builder compatibility
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'symbol' instead.")
    @IBInspectable var symbolInt: Int = 0 {
        willSet { if let newSymbol = Symbol(rawValue: newValue) { symbol = newSymbol } }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'shading' instead.")
    @IBInspectable var shadingInt: Int = 0 {
        willSet { if let newShading = Shading(rawValue: newValue) { shading = newShading } }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'state' instead.")
    @IBInspectable var stateName: String? = "none" {
        willSet { if let newState = State(rawValue: newValue?.lowercased() ?? "") { state = newState } }
    }
    
    // MARK: - Constants

    private struct SizeRatio {
        static let cornerRadiusToBoundsWidth: CGFloat = 0.08
        static let symbolLineWidthToBoundsWidth: CGFloat = 0.01
    }
    private var cornerRadius: CGFloat { return bounds.width * SizeRatio.cornerRadiusToBoundsWidth }
    private var symbolLineWidth: CGFloat { return bounds.width * SizeRatio.symbolLineWidthToBoundsWidth }
    

    // MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        // card background and shape
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.white.setFill()
        roundedRect.fill()
        
        // symbols
        let symbolsPath = UIBezierPath()
        for index in 0..<number {
            symbolsPath.append(pathForSymbolInBounds(boundsForSymbolInPosition(index)))
        }
        switch shading {
            case .solid:
                color.setFill()
                symbolsPath.fill()
            case .striped:
                color.setStroke()
                symbolsPath.lineWidth = symbolLineWidth
                symbolsPath.stroke()
                symbolsPath.addClip()
                stripCard()
            case .open:
                color.setStroke()
                symbolsPath.lineWidth = symbolLineWidth
                symbolsPath.stroke()
        }
        
        // card state
        layer.cornerRadius = cornerRadius
        layer.borderWidth = symbolLineWidth * 5.0
        layer.borderColor = state.color
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
        
        let marginX = bounds.width * 0.08
        let marginY = bounds.height * 0.08
        let boundsWithMargin = self.bounds.insetBy(dx: marginX, dy: marginY)
        let symbolHeight = boundsWithMargin.height / 3.0
        return CGRect(x: boundsWithMargin.origin.x, y: boundsWithMargin.origin.y + symbolHeight * yPositionMultiplier,
                      width: boundsWithMargin.width, height: symbolHeight).insetBy(dx: marginX * 0.5, dy: marginY * 0.4)
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
        let path = UIBezierPath()
        let origin = bounds.topLeft.offsetBy(dx: bounds.width * 0.065, dy: bounds.height * 0.25)
        path.move(to: origin)
        
        path.addCurve(to: bounds.topRight.offsetBy(dx: -bounds.width * 0.15, dy: bounds.height * 0.06),
                      controlPoint1: bounds.topLeft.offsetBy(dx: bounds.width * 0.25, dy: -bounds.height * 0.275),
                      controlPoint2: bounds.center)
        
        path.addQuadCurve(to: bounds.topRight.offsetBy(dx: -bounds.width * 0.047, dy: bounds.height * 0.094),
                          controlPoint: bounds.topRight.offsetBy(dx: -bounds.width * 0.083, dy: 0.0))
        
        path.addQuadCurve(to: bounds.bottomRight.offsetBy(dx: -bounds.width * 0.065, dy: -bounds.size.height * 0.375),
                          controlPoint: bounds.topRight.offsetBy(dx: bounds.width * 0.03, dy: bounds.height * 0.3))
        
        path.addCurve(to: bounds.bottomLeft.offsetBy(dx: bounds.width * 0.167, dy: -bounds.height * 0.06),
                      controlPoint1: bounds.bottomRight.offsetBy(dx: -bounds.width * 0.3, dy: bounds.height * 0.275),
                      controlPoint2: bounds.center.offsetBy(dx: 0.0, dy: bounds.height * 0.05))
        
        path.addQuadCurve(to: bounds.bottomLeft.offsetBy(dx: bounds.width * 0.06, dy: -bounds.height * 0.094),
                          controlPoint: bounds.bottomLeft.offsetBy(dx: bounds.width * 0.1, dy: 0.0))
        
        path.addQuadCurve(to: origin, controlPoint: bounds.bottomLeft.offsetBy(dx: -bounds.width * 0.05, dy: -bounds.height * 0.375))
        return path
    }
    
    private func stripCard() {
        for positionX in stride(from: bounds.minX, to: bounds.maxX, by: bounds.width / 50.0) {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: positionX, y: bounds.minY))
            path.addLine(to: CGPoint(x: positionX, y: bounds.maxY))
            color.setStroke()
            path.lineWidth = symbolLineWidth * 0.25
            path.stroke()
        }
    }
    
    
    // MARK: - Enumerations
    
    enum Symbol: Int {
        case diamond, squiggle, oval
    }
    
    enum Shading: Int {
        case solid, striped, open
    }
    
    enum State: String {
        case none, selected, matched, mismatched, cheated
        
        var color: CGColor {
            switch self {
                case .none: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                case .selected: return #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                case .matched: return #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
                case .mismatched: return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                case .cheated: return #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
            }
        }
    }

}
