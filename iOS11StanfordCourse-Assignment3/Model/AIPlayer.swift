//
//  AIPlayer.swift
//  iOS11StanfordCourse-Assignment2
//
//  Created by Natxo Raga Llorens on 21/8/18.
//  Copyright © 2018 Natxo Raga. All rights reserved.
//

import Foundation


class AIPlayer {
    
    // MARK: - Constants
    
    private struct Constants {
        static let minThinkingTime = 20.0
        static let maxThinkingTime = 30.0
        static let almostDoneOffsetTime = 5.0
    }
    
    // MARK: - Status
    
    enum Status {
        case idle
        case thinking
        case almostDone
        case matchFound
        case matchLost
    }
    
    private(set) var status = Status.idle
    
    // MARK: - Timers
    
    private weak var almostDoneTimer: Timer?
    private weak var searchFinishedTimer: Timer?
    
    
    // MARK: - Public API
    
    func searchMatch(onAlmostDone almostDoneCallback: @escaping () -> Void, onSearchFinished searchFinishedCallback: @escaping () -> Void) {
        status = .thinking
        if searchFinishedTimer == nil {
            let timeInterval = Double.random(min: Constants.minThinkingTime, max: Constants.maxThinkingTime)
            almostDoneTimer = Timer.scheduledTimer(withTimeInterval: timeInterval - Constants.almostDoneOffsetTime, repeats: false) { timer in
                self.status = .almostDone
                almostDoneCallback()
            }
            searchFinishedTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { timer in
                self.status = .matchFound
                searchFinishedCallback()
            }
        }
    }
    
    func stopSearching() {
        status = .matchLost
        almostDoneTimer?.invalidate()
        searchFinishedTimer?.invalidate()
    }
    
}
