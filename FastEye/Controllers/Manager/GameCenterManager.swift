//
//  GameCenterManager.swift
//  FastEye
//
//  Created by Nicholas Allio on 12/06/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit
import GameKit

private enum LeaderboardID: String {
    case main = "nicholas.allio.fasteye"
    case upCount = "nicholas.allio.fasteye.upcount"
    case downCount = "nicholas.allio.fasteye.downcount"
    case random = "nicholas.allio.fasteye.random"
}

private enum UserDefaultHighScore: String {
    case upCount = "kUserDefaultHighScoreUpcount"
    case downCount = "UserDefaultHighScoreDownCount"
    case random = "UserDefaultHighScoreRandom"
}

class GameCenterManager: NSObject {
    var gcEnabled: Bool = false
    
    static private var _sharedInstance: GameCenterManager!
    private let leaderborad = GKLeaderboard()
    private var _leaderboardViewController: GKGameCenterViewController!
    
    class func sharedInstance() -> GameCenterManager! {
        if _sharedInstance == nil {
            _sharedInstance = GameCenterManager()
        }
        return _sharedInstance
    }
    
    func isEnabled() -> Bool {
        return self.gcEnabled
    }
    
    func loadHighScoresFromGameCenter() {
        if self.isEnabled() {
            // UpCount score
            weak var weakSelf : GameCenterManager! = self
            self.leaderborad.identifier = LeaderboardID.upCount.rawValue
            self.leaderborad.loadScores(completionHandler: { (scores, error) in
                if error == nil, let localPlayerScore = weakSelf.leaderborad.localPlayerScore {
                    weakSelf.saveHighScoreLocaly(withHighScore: localPlayerScore.value, forModeGameKey: .upCount)
                }
            })
            
            // DownCount score
            self.leaderborad.identifier = LeaderboardID.downCount.rawValue
            self.leaderborad.loadScores(completionHandler: { (scores, error) in
                if error == nil, let localPlayerScore = weakSelf.leaderborad.localPlayerScore {
                    weakSelf.saveHighScoreLocaly(withHighScore: localPlayerScore.value, forModeGameKey: .downCount)
                }
            })
            
            // Random score
            self.leaderborad.identifier = LeaderboardID.random.rawValue
            self.leaderborad.loadScores(completionHandler: { (scores, error) in
                if error == nil, let localPlayerScore = weakSelf.leaderborad.localPlayerScore {
                    weakSelf.saveHighScoreLocaly(withHighScore: localPlayerScore.value, forModeGameKey: .random)
                }
            })
        }
    }
    
    func getHighScoreForGameMode(gameMode: GameMode) -> Double? {
        switch gameMode {
        case .UpCount:
            let int64Value = UserDefaults.standard.double(forKey: UserDefaultHighScore.upCount.rawValue)
            return Double(int64Value/100)
        case .DownCount:
            let int64Value = UserDefaults.standard.double(forKey: UserDefaultHighScore.downCount.rawValue)
            return Double(int64Value/100)
        case .Random:
            let int64Value = UserDefaults.standard.double(forKey: UserDefaultHighScore.random.rawValue)
            return Double(int64Value/100)
        }
    }
    
    func submitHighScoreToGameCenter(highScore: Double, inMode: GameMode) {
        var leaderboardID = ""
        var userDefaultKey : UserDefaultHighScore
        switch inMode {
        case .UpCount:
            leaderboardID = LeaderboardID.upCount.rawValue
            userDefaultKey = .upCount
            break
        case .DownCount:
            leaderboardID = LeaderboardID.downCount.rawValue
            userDefaultKey = .downCount
            break
        case .Random:
            leaderboardID = LeaderboardID.random.rawValue
            userDefaultKey = .random
            break
        }
        
        let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardID)
        bestScoreInt.value = Int64(highScore*100)
        
        GKScore.report([bestScoreInt], withCompletionHandler: nil)
        saveHighScoreLocaly(withHighScore: bestScoreInt.value, forModeGameKey: userDefaultKey)
    }
    
    func getGameCenterLeaderboardViewController() -> GKGameCenterViewController {
        if _leaderboardViewController == nil {
            _leaderboardViewController = GKGameCenterViewController()
            _leaderboardViewController.viewState = .leaderboards
            _leaderboardViewController.gameCenterDelegate = self
        }
        return _leaderboardViewController
    }
    
    private func saveHighScoreLocaly(withHighScore highScore: Int64, forModeGameKey userDefaultKey: UserDefaultHighScore) {
        objc_sync_enter(self)
        UserDefaults.standard.set(highScore, forKey: userDefaultKey.rawValue)
        UserDefaults.standard.synchronize()
        objc_sync_exit(self)
    }
    
}

extension GameCenterManager : GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticateGameCenterUser(successBlockOrViewController: @escaping (Bool, UIViewController?)->()) -> Void {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        weak var weakSelf : GameCenterManager! = self
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if let vc = viewController {
                // 1. Show login if player is not logged in
                successBlockOrViewController(error == nil, vc)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                weakSelf.gcEnabled = true
                weakSelf.loadHighScoresFromGameCenter()
                successBlockOrViewController(true, nil)
            } else {
                // 3. Game center is not enabled on the users device
                weakSelf.gcEnabled = false
                successBlockOrViewController(false, nil)
            }
        }
    }
    
}
