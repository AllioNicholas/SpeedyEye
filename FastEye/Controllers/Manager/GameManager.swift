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

let GameInitialValue = "kGameInitialValue"
let GameColor = "kGameColor"

class GameManager: NSObject {
    
    var currentGameMode: GameMode
    var valueToBeSelected: Int
    
    init(gameMode: GameMode, initialSetup: @escaping ([String: Any])->()) {
        currentGameMode = gameMode
        
        var returningSetup: [String:Any]
        switch self.currentGameMode {
        case .UpCount:
            self.valueToBeSelected = 1
            returningSetup = [
                GameInitialValue: 1,
                GameColor: UpCountModeColor
            ]
            break
        case .DownCount:
            self.valueToBeSelected = 25
            returningSetup = [
                GameInitialValue: 25,
                GameColor: DownCountModeColor
            ]
            break
        case .Random:
            var num = Int(arc4random_uniform(26))
            while num == 0 {
                num = Int(arc4random_uniform(26))
            }
            self.valueToBeSelected = Int(num)
            returningSetup = [
                GameInitialValue: Int(num),
                GameColor: RandomModeColor
            ]
            break
        }
        
        initialSetup(returningSetup)
    }
    
    func didSelectValue(value: Int, withResultBlock: @escaping (Bool, Int)->()) {
        switch self.currentGameMode {
        case .UpCount:
            break
        case .DownCount:
            break
        case .Random:
            break
        }
    }
    
}
