//
//  SetCardGrid.swift
//  iOS11StanfordCourse-Assignment3
//
//  Created by Natxo Raga Llorens on 25/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import UIKit


class SetCardsGrid: UIView {

    var cardViews = [SetCardView]() { didSet { setNeedsLayout() } }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // remove all cards from view
        for cardView in subviews {
            cardView.removeFromSuperview()
        }
        
        // position and add cards
        var grid = Grid(layout: .aspectRatio(10 / 16), frame: bounds)
        grid.cellCount = cardViews.count
        for (index, cardView) in cardViews.enumerated() {
            cardView.frame = grid[index]!.insetBy(dx: grid[index]!.width * 0.03, dy: grid[index]!.width * 0.03)
            cardView.isOpaque = false
            addSubview(cardView)
        }
    }

}
