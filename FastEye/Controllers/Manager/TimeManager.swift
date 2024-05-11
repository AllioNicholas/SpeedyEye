//
//  TimeManager.swift
//  FastEye
//
//  Created by Nicholas Allio on 30/01/2019.
//  Copyright © 2019 Nicholas Allio. All rights reserved.
//

import UIKit

class TimeManager: NSObject {
    
    private var gameTimer: Timer = Timer()
    private var elapsedTime = 0.0
    
    lazy var isTimeRunning: Bool = {
        return self.gameTimer.isValid
    }()
    
    lazy var finalTime: Double? = {
        guard !self.isTimeRunning else { return nil }
        
        return self.elapsedTime
    }()
    
    override init() {
        super.init()
    }
    
    convenience init(_ updateBlock: @escaping (String) -> Void ) {
        self.init()
        self.gameTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (_) in
            self.elapsedTime += 0.01
            if self.elapsedTime >= 60.0 {
                let minutes = Int(self.elapsedTime / 60)
                let secAndMill = self.elapsedTime - Double(60 * minutes)
                updateBlock(NSString(format: "%d:%05.2f", minutes, secAndMill) as String)
            } else {
                updateBlock(NSString(format: "%.2f", self.elapsedTime) as String)
            }
        })
    }
    
    func stopTimer() {
        self.gameTimer.invalidate()
    }
}
