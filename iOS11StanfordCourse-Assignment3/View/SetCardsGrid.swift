//
//  SetCardGrid.swift
//  iOS11StanfordCourse-Assignment3
//
//  Created by Natxo Raga Llorens on 25/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import UIKit


class SetCardsGrid: UIView {

    // MARK: - Constants
    
    private struct Constants {
        static let aspectRatio: CGFloat = 10.0 / 16.0
        static let cardViewFrameInsetToWidthRatio: CGFloat = 0.03
    }
    
    
    // MARK: - Gesture recognizers
    
    var cardsTapGestureRecognizerTarget: UIViewController?
    var cardsTapGestureRecognizerAction: Selector?
    
    
    // MARK: - Subviews
    
    var cardViews = [SetCardView]() { didSet { setNeedsLayout() } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // remove all cards from view
        for cardView in subviews { cardView.removeFromSuperview() }
        
        // setup card grid
        var grid = Grid(layout: .aspectRatio(Constants.aspectRatio), frame: bounds)
        grid.cellCount = cardViews.count
        
        // add cards to grid
        for (index, cardView) in cardViews.enumerated() {
            cardView.frame = grid[index]!.insetBy(dx: grid[index]!.width * Constants.cardViewFrameInsetToWidthRatio,
                                                  dy: grid[index]!.width * Constants.cardViewFrameInsetToWidthRatio)
            cardView.isOpaque = false
            cardView.contentMode = .redraw
            if cardsTapGestureRecognizerTarget != nil && cardsTapGestureRecognizerAction != nil {
                cardView.addGestureRecognizer(UITapGestureRecognizer(target: cardsTapGestureRecognizerTarget, action: cardsTapGestureRecognizerAction))
            }
            addSubview(cardView)
        }
    }

}
