//
//  AIPlayer.swift
//  iOS11StanfordCourse-Assignment2
//
//  Created by Natxo Raga Llorens on 21/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import Foundation


class AIPlayer {
    
    private static let minThinkingTime = 20.0
    private static let maxThinkingTime = 30.0
    
    private(set) var status = AIPlayerStatus.idle
    
    private var almostDoneTimer: Timer?
    private var searchFinishedTimer: Timer?
    
    
    func searchMatch(onAlmostDone almostDoneCallback: @escaping () -> Void, onSearchFinished searchFinishedCallback: @escaping () -> Void) {
        status = .thinking
        if searchFinishedTimer == nil {
            let timeInterval = Double.random(min: AIPlayer.minThinkingTime, max: AIPlayer.maxThinkingTime)
            almostDoneTimer = Timer.scheduledTimer(withTimeInterval: timeInterval - 5.0, repeats: false) { (timer) in
                self.status = .almostDone
                almostDoneCallback()
            }
            searchFinishedTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { (timer) in
                self.status = .matchFound
                searchFinishedCallback()
            }
        }
    }
    
    func stopSearching() {
        status = .matchLost
        almostDoneTimer?.invalidate()
        searchFinishedTimer?.invalidate()
        almostDoneTimer = nil
        searchFinishedTimer = nil
    }
    
}

enum AIPlayerStatus {
    case idle
    case thinking
    case almostDone
    case matchFound
    case matchLost
}
