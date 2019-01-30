//
//  GameManager.swift
//  FastEye
//
//  Created by Nicholas Allio on 25/09/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

enum GameMode : Int {
    case UpCount
    case DownCount
    case Random
}

private let UpCountModeColor = UIColor(netHex: 0x332433) //Viola
private let DownCountModeColor = UIColor(netHex: 0x4A5B82) //Azzurro scuro
private let RandomModeColor = UIColor(netHex: 0x6FA79A) //Verde acqua

private let UpCountModeInitialValue = 1
private let DownCountModeInitialValue = 25
private let RandomModeInitialValue = Int(arc4random_uniform(25) + 1)

let GameInitialValue = "kGameInitialValue"
let GameColor = "kGameColor"

class GameManager: NSObject {
    
    var currentGameMode: GameMode = .UpCount
    var valueToBeSelected: Int = 0
    
    var randomSelectedValues: [Int] = [0]
    
    override init() {
        super.init()
    }
    
    convenience init(gameMode: GameMode, initialSetup: @escaping ([String: Any])->()) {
        self.init()
        self.currentGameMode = gameMode
        
        var returningSetup: [String:Any]
        switch self.currentGameMode {
        case .UpCount:
            self.valueToBeSelected = UpCountModeInitialValue
            returningSetup = [
                GameInitialValue: UpCountModeInitialValue,
                GameColor: UpCountModeColor
            ]
            break
        case .DownCount:
            self.valueToBeSelected = DownCountModeInitialValue
            returningSetup = [
                GameInitialValue: DownCountModeInitialValue,
                GameColor: DownCountModeColor
            ]
            break
        case .Random:
            self.valueToBeSelected = RandomModeInitialValue
            returningSetup = [
                GameInitialValue: RandomModeInitialValue,
                GameColor: RandomModeColor
            ]
            break
        }
        
        initialSetup(returningSetup)
    }
    
    func didSelectValue(value: Int) -> (finish:Bool, correct:Bool, nextValue:Int) {
        let correctSelection = self.valueToBeSelected == value
        switch self.currentGameMode {
        case .UpCount:
            self.valueToBeSelected = correctSelection ? self.valueToBeSelected + 1 : UpCountModeInitialValue
            return (self.valueToBeSelected == 26, correctSelection, self.valueToBeSelected)
        case .DownCount:
            self.valueToBeSelected = correctSelection ? self.valueToBeSelected - 1 : DownCountModeInitialValue
            return (self.valueToBeSelected == 0, correctSelection, self.valueToBeSelected)
        case .Random:
            var num = arc4random() % 26
            while self.randomSelectedValues.contains(Int(num)) {
                num = arc4random() % 26
            }
            if correctSelection {
                self.randomSelectedValues.append(Int(num))
                self.valueToBeSelected = Int(num)
            } else {
                self.randomSelectedValues = [0]
                self.valueToBeSelected = RandomModeInitialValue
            }
            return (self.randomSelectedValues.count == 26, correctSelection, self.valueToBeSelected)
        }
    }
    
}
