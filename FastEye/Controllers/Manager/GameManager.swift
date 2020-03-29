//
//  GameManager.swift
//  FastEye
//
//  Created by Nicholas Allio on 25/09/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

enum GameMode: Int {
    case upCount
    case downCount
    case random
}

private let upCountModeColor = UIColor(netHex: 0x332433) //Viola
private let downCountModeColor = UIColor(netHex: 0x4A5B82) //Azzurro scuro
private let randomModeColor = UIColor(netHex: 0x6FA79A) //Verde acqua

private let upCountModeInitialValue = 1
private let downCountModeInitialValue = 25
private let randomModeInitialValue = Int(arc4random_uniform(25) + 1)

let kGameInitialValue = "kGameInitialValue"
let kGameColor = "kGameColor"

class GameManager: NSObject {
    
    private var timeManager: TimeManager = TimeManager()

    private var currentGameMode: GameMode = .upCount
    private var valueToBeSelected: Int = 0
    
    private var randomSelectedValues: [Int] = [0]
    
    var timeUpdateBlock: ((String) -> Void)?
    
    override init() {
        super.init()
    }
    
    convenience init(gameMode: GameMode, initialSetup: @escaping ([String: Any]) -> Void) {
        self.init()
        self.currentGameMode = gameMode
        
        var returningSetup: [String: Any]
        switch self.currentGameMode {
        case .upCount:
            self.valueToBeSelected = upCountModeInitialValue
            returningSetup = [
                kGameInitialValue: upCountModeInitialValue,
                kGameColor: upCountModeColor
            ]
        case .downCount:
            self.valueToBeSelected = downCountModeInitialValue
            returningSetup = [
                kGameInitialValue: downCountModeInitialValue,
                kGameColor: downCountModeColor
            ]
        case .random:
            self.valueToBeSelected = randomModeInitialValue
            returningSetup = [
                kGameInitialValue: randomModeInitialValue,
                kGameColor: randomModeColor
            ]
        }
        
        initialSetup(returningSetup)
    }
    
    func startGame() {
        self.timeManager = TimeManager({ [weak self] (timeString) in
            guard let timeUpdateBlock = self?.timeUpdateBlock else { return }
            timeUpdateBlock(timeString)
        })
    }
    
    func stopTimer() {
        self.timeManager.stopTimer()
    }
    
    func endGame() {
        stopTimer()
        
        //        if self.elapsedTime < self.highscore {
        //            switch inMode {
        //            case .UpCount:
        //                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_up")
        //                break
        //            case .DownCount:
        //                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_down")
        //                break
        //            case .Random:
        //                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_rand")
        //                break
        //            }
        //        }
        
//GameCenterManager
//            .sharedInstance()
//            .submitHighScoreToGameCenter(highScore: self.elapsedTime, inMode: self.gameMode)

    }
    
    func finalTime() -> Double? {
        return self.timeManager.finalTime()
    }
    
    func isHighScore() -> Bool {
        guard !self.timeManager.isTimeRunning(),
            let elapsedTime = self.finalTime(),
            let highscoreForGameMode = GameCenterManager
                                        .shared
                                        .getHighScoreForGameMode(self.currentGameMode)
            else { return false }
        
        return elapsedTime < highscoreForGameMode
    }
    
    // swiftlint:disable large_tuple
    func didSelectValue(value: Int) -> (finish: Bool, correct: Bool, nextValue: Int) {
        let correctSelection = self.valueToBeSelected == value
        switch self.currentGameMode {
        case .upCount:
            self.valueToBeSelected = correctSelection ? self.valueToBeSelected + 1 : upCountModeInitialValue

            if self.valueToBeSelected == 26 { self.endGame() }

            return (self.valueToBeSelected == 26, correctSelection, self.valueToBeSelected)
        case .downCount:
            self.valueToBeSelected = correctSelection ? self.valueToBeSelected - 1 : downCountModeInitialValue

            if self.valueToBeSelected == 0 { self.endGame() }

            return (self.valueToBeSelected == 0, correctSelection, self.valueToBeSelected)
        case .random:
            var num = arc4random() % 26
            while self.randomSelectedValues.contains(Int(num)) {
                num = arc4random() % 26
            }
            if correctSelection {
                self.randomSelectedValues.append(Int(num))
                self.valueToBeSelected = Int(num)
            } else {
                self.randomSelectedValues = [0]
                self.valueToBeSelected = randomModeInitialValue
            }
            
            if self.randomSelectedValues.count == 26 { self.endGame() }

            return (self.randomSelectedValues.count == 26, correctSelection, self.valueToBeSelected)
        }
    }
    
}
