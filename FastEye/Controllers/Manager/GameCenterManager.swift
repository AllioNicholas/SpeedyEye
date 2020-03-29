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
    
    lazy private var leaderborad: GKLeaderboard = {
        let leaderboard = GKLeaderboard()
        leaderboard.timeScope = .allTime
        return leaderboard
    }()
    
    lazy var leaderboardViewController: GKGameCenterViewController = {
        let leaderboardVC = GKGameCenterViewController()
        leaderboardVC.viewState = .leaderboards
        leaderboardVC.gameCenterDelegate = self
        return leaderboardVC
    }()
    
    static let shared = GameCenterManager()
    
    var isEnabled: Bool {
        return self.gcEnabled
    }
    
    func loadHighScoresFromGameCenter() {
        if isEnabled {
            
            // UpCount score
            self.leaderborad.identifier = LeaderboardID.upCount.rawValue
            self.leaderborad.loadScores(completionHandler: { [weak self] (_, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let localPlayerScore = self.leaderborad.localPlayerScore {
                    self.saveHighScoreLocaly(withHighScore: localPlayerScore.value,
                                                 forModeGameKey: .upCount)
                }
            })
            
            // DownCount score
            self.leaderborad.identifier = LeaderboardID.downCount.rawValue
            self.leaderborad.loadScores(completionHandler: { [weak self] (_, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let localPlayerScore = self.leaderborad.localPlayerScore {
                    self.saveHighScoreLocaly(withHighScore: localPlayerScore.value,
                                                 forModeGameKey: .downCount)
                }
            })
            
            // Random score
            self.leaderborad.identifier = LeaderboardID.random.rawValue
            self.leaderborad.loadScores(completionHandler: { [weak self] (_, error) in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let localPlayerScore = self.leaderborad.localPlayerScore {
                    self.saveHighScoreLocaly(withHighScore: localPlayerScore.value,
                                                 forModeGameKey: .random)
                }
            })
        }
    }
    
    func getHighScoreForGameMode( _ gameMode: GameMode) -> Double? {
        switch gameMode {
        case .upCount:
            let int64Value = UserDefaults.standard.double(forKey: UserDefaultHighScore.upCount.rawValue)
            return int64Value > 0 ? Double(int64Value/100) : nil
        case .downCount:
            let int64Value = UserDefaults.standard.double(forKey: UserDefaultHighScore.downCount.rawValue)
            return int64Value > 0 ? Double(int64Value/100) : nil
        case .random:
            let int64Value = UserDefaults.standard.double(forKey: UserDefaultHighScore.random.rawValue)
            return int64Value > 0 ? Double(int64Value/100) : nil
        }
    }
    
    func submitHighScoreToGameCenter(highScore: Double, inMode: GameMode) {
        var leaderboardID = ""
        var userDefaultKey: UserDefaultHighScore
        switch inMode {
        case .upCount:
            leaderboardID = LeaderboardID.upCount.rawValue
            userDefaultKey = .upCount
        case .downCount:
            leaderboardID = LeaderboardID.downCount.rawValue
            userDefaultKey = .downCount
        case .random:
            leaderboardID = LeaderboardID.random.rawValue
            userDefaultKey = .random
        }
        
        let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardID)
        bestScoreInt.value = Int64(highScore*100)
        
        GKScore.report([bestScoreInt], withCompletionHandler: nil)
        saveHighScoreLocaly(withHighScore: bestScoreInt.value, forModeGameKey: userDefaultKey)
    }
    
    private func saveHighScoreLocaly(
        withHighScore highScore: Int64,
        forModeGameKey userDefaultKey: UserDefaultHighScore) {
        UserDefaults.standard.set(highScore, forKey: userDefaultKey.rawValue)
    }
    
}

extension GameCenterManager: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticateGameCenterUser(
        successBlockOrViewController: @escaping (Bool, UIViewController?) -> Void) {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { [weak self] (viewController, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let viewController = viewController {
                // 1. Show login if player is not logged in
                successBlockOrViewController(error == nil, viewController)
            } else if localPlayer.isAuthenticated {
                // 2. Player is already authenticated & logged in, load game center
                self?.gcEnabled = true
                self?.loadHighScoresFromGameCenter()
                successBlockOrViewController(true, nil)
            } else {
                // 3. Game center is not enabled on the users device
                self?.gcEnabled = false
                successBlockOrViewController(false, nil)
            }
        }
    }
    
}
