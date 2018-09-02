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

    private struct CardSizeRatio {
        static let cornerRadiusToBoundsWidth: CGFloat = 0.08
        static let borderWidthToBoundsWidth: CGFloat = 0.05
        static let marginWidthToBoundsWidth: CGFloat = 0.08
        static let marginHeightToBoundsHeight: CGFloat = 0.08
    }
    private var cornerRadius: CGFloat { return bounds.width * CardSizeRatio.cornerRadiusToBoundsWidth }
    private var borderWidth: CGFloat { return bounds.width * CardSizeRatio.borderWidthToBoundsWidth }
    private var marginWidth: CGFloat { return bounds.width * CardSizeRatio.marginWidthToBoundsWidth }
    private var marginHeight: CGFloat { return bounds.height * CardSizeRatio.marginHeightToBoundsHeight }
    
    private struct SymbolSizeRatio {
        static let lineWidthToBoundsWidth: CGFloat = 0.01
        static let marginWidthToBoundsWidth: CGFloat = 0.04
        static let marginHeightToBoundsHeight: CGFloat = 0.03
        static let stripDistanceToBoundsWidth: CGFloat = 0.02
        static let stripLineWidthToBoundsWidth: CGFloat = SymbolSizeRatio.lineWidthToBoundsWidth * 0.25
    }
    private var symbolLineWidth: CGFloat { return bounds.width * SymbolSizeRatio.lineWidthToBoundsWidth }
    private var symbolMarginWidth: CGFloat { return bounds.width * SymbolSizeRatio.marginWidthToBoundsWidth }
    private var symbolMarginHeight: CGFloat { return bounds.height * SymbolSizeRatio.marginHeightToBoundsHeight }
    private var stripDistance: CGFloat { return bounds.width * SymbolSizeRatio.stripDistanceToBoundsWidth }
    private var stripLineWidth: CGFloat { return bounds.width * SymbolSizeRatio.stripLineWidthToBoundsWidth }
    
    private func squiggleOrigin(in bounds: CGRect) -> CGPoint { return bounds.topLeft.offsetBy(dx: bounds.width * 0.065, dy: bounds.height * 0.25) }
    private func squiggleFirstCurveEndPoint(in bounds: CGRect) -> CGPoint { return bounds.topRight.offsetBy(dx: -bounds.width * 0.15, dy: bounds.height * 0.06) }
    private func squiggleFirstCurveControlPoint1(in bounds: CGRect) -> CGPoint { return bounds.topLeft.offsetBy(dx: bounds.width * 0.25, dy: -bounds.height * 0.275) }
    private func squiggleFirstCurveControlPoint2(in bounds: CGRect) -> CGPoint { return bounds.center }
    private func squiggleSecondCurveEndPoint(in bounds: CGRect) -> CGPoint { return bounds.topRight.offsetBy(dx: -bounds.width * 0.047, dy: bounds.height * 0.094) }
    private func squiggleSecondCurveControlPoint(in bounds: CGRect) -> CGPoint { return bounds.topRight.offsetBy(dx: -bounds.width * 0.083, dy: 0.0) }
    private func squiggleThirdCurveEndPoint(in bounds: CGRect) -> CGPoint { return bounds.bottomRight.offsetBy(dx: -bounds.width * 0.065, dy: -bounds.size.height * 0.375) }
    private func squiggleThirdCurveControlPoint(in bounds: CGRect) -> CGPoint { return bounds.topRight.offsetBy(dx: bounds.width * 0.03, dy: bounds.height * 0.3) }
    private func squiggleFourthCurveEndPoint(in bounds: CGRect) -> CGPoint { return bounds.bottomLeft.offsetBy(dx: bounds.width * 0.167, dy: -bounds.height * 0.06) }
    private func squiggleFourthCurveControlPoint1(in bounds: CGRect) -> CGPoint { return bounds.bottomRight.offsetBy(dx: -bounds.width * 0.3, dy: bounds.height * 0.275) }
    private func squiggleFourthCurveControlPoint2(in bounds: CGRect) -> CGPoint { return bounds.center.offsetBy(dx: 0.0, dy: bounds.height * 0.05) }
    private func squiggleFifthCurveEndPoint(in bounds: CGRect) -> CGPoint { return bounds.bottomLeft.offsetBy(dx: bounds.width * 0.06, dy: -bounds.height * 0.094) }
    private func squiggleFifthCurveControlPoint(in bounds: CGRect) -> CGPoint { return bounds.bottomLeft.offsetBy(dx: bounds.width * 0.1, dy: 0.0) }
    private func squiggleSixthCurveControlPoint(in bounds: CGRect) -> CGPoint { return bounds.bottomLeft.offsetBy(dx: -bounds.width * 0.05, dy: -bounds.height * 0.375) }
    

    // MARK: - Draw
    
    override func draw(_ rect: CGRect) {
        // card background and shape
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.white.setFill()
        roundedRect.fill()
        
        // symbols
        let symbolsPath = UIBezierPath()
        for index in 0..<number {
            symbolsPath.append(pathForSymbol(in: boundsForSymbol(at: index)))
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
        layer.borderWidth = borderWidth
        layer.borderColor = state.color
    }
    
    private func boundsForSymbol(at position: Int) -> CGRect {
        var yPositionMultiplier: CGFloat = 0.0
        switch number {
            case 1: yPositionMultiplier = 1.0
            case 2: yPositionMultiplier = 0.5
            case 3: yPositionMultiplier = 0.0
            default: break
        }
        yPositionMultiplier += CGFloat(position)
        
        let boundsWithMargin = bounds.insetBy(dx: marginWidth, dy: marginHeight)
        let symbolHeight = boundsWithMargin.height / 3.0
        return CGRect(x: boundsWithMargin.origin.x, y: boundsWithMargin.origin.y + symbolHeight * yPositionMultiplier,
                      width: boundsWithMargin.width, height: symbolHeight).insetBy(dx: symbolMarginWidth, dy: symbolMarginHeight)
    }
    
    private func pathForSymbol(in bounds: CGRect) -> UIBezierPath {
        switch symbol {
            case .diamond:
                let path = UIBezierPath()
                path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
                path.addLine(to: CGPoint(x: bounds.midX, y: bounds.minY))
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
                path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
                path.close()
                return path
            case .squiggle: return pathForSquiggle(in: bounds)
            case .oval: return UIBezierPath(ovalIn: bounds)
        }
    }
    
    private func pathForSquiggle(in bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: squiggleOrigin(in: bounds))
        path.addCurve(to: squiggleFirstCurveEndPoint(in: bounds), controlPoint1: squiggleFirstCurveControlPoint1(in: bounds), controlPoint2: squiggleFirstCurveControlPoint2(in: bounds))
        path.addQuadCurve(to: squiggleSecondCurveEndPoint(in: bounds), controlPoint: squiggleSecondCurveControlPoint(in: bounds))
        path.addQuadCurve(to: squiggleThirdCurveEndPoint(in: bounds), controlPoint: squiggleThirdCurveControlPoint(in: bounds))
        path.addCurve(to: squiggleFourthCurveEndPoint(in: bounds), controlPoint1: squiggleFourthCurveControlPoint1(in: bounds), controlPoint2: squiggleFourthCurveControlPoint2(in: bounds))
        path.addQuadCurve(to: squiggleFifthCurveEndPoint(in: bounds), controlPoint: squiggleFifthCurveControlPoint(in: bounds))
        path.addQuadCurve(to: squiggleOrigin(in: bounds), controlPoint: squiggleSixthCurveControlPoint(in: bounds))
        return path
    }
    
    private func stripCard() {
        for positionX in stride(from: bounds.minX, to: bounds.maxX, by: stripDistance) {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: positionX, y: bounds.minY))
            path.addLine(to: CGPoint(x: positionX, y: bounds.maxY))
            color.setStroke()
            path.lineWidth = stripLineWidth
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
