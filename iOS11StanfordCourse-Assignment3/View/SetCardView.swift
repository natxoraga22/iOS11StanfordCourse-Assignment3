//
//  SetCardView.swift
//  iOS11StanfordCourse-Assignment3
//
//  Created by Natxo Raga Llorens on 22/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import UIKit


class SetCardView: UIView {

    let number: Int = 1
    let symbol: Symbol = .diamond
    let shading: Shading = .solid
    let color: UIColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

    
    override func draw(_ rect: CGRect) {

    }
    
    
    // MARK: Enums
    
    enum Symbol {
        case diamond, squiggle, oval
    }
    
    enum Shading {
        case solid, striped, open
    }

}
