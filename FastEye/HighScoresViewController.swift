//
//  HighScoresViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 12/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import GameKit

class HighScoresViewController: UIViewController {
    
    @IBOutlet weak var upHS: UILabel!
    @IBOutlet weak var downHS: UILabel!
    @IBOutlet weak var randomHS: UILabel!
    
    var navigation_buttonSound : SystemSoundID = 0
    var bestTime = DBL_MAX
    var defaultHS = LeaderboardID.main.rawValue
    
    override func viewDidLoad() {
        let filePath = Bundle.main.path(forResource: "navigation_button", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &navigation_buttonSound)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let hs = UserDefaults.standard.value(forKey: "highscore_up") {
            let highscore = Double(hs as! NSNumber)
            if highscore < bestTime {
                bestTime = highscore
                defaultHS = LeaderboardID.upCount.rawValue
            }
            upHS.text = NSString(format: "Up Count:\n%.2f", highscore) as String
            submitHighScoreToGC(highScore: highscore, inMode: GameMode.upCount)
        } else {
            upHS.text = "Up Count:\n-.-"
        }
        
        if let hs = UserDefaults.standard.value(forKey: "highscore_down") {
            let highscore = Double(hs as! NSNumber)
            if highscore < bestTime {
                bestTime = highscore
                defaultHS = LeaderboardID.downCount.rawValue
            }
            downHS.text = NSString(format: "Down Count:\n%.2f", highscore) as String
            submitHighScoreToGC(highScore: highscore, inMode: GameMode.downCount)
        } else {
            downHS.text = "Down Count:\n-.-"
        }
        
        if let hs = UserDefaults.standard.value(forKey: "highscore_rand") {
            let highscore = Double(hs as! NSNumber)
            if highscore < bestTime {
                bestTime = highscore
                defaultHS = LeaderboardID.random.rawValue
            }
            randomHS.text = NSString(format: "Random Count:\n%.2f", highscore) as String
            submitHighScoreToGC(highScore: highscore, inMode: GameMode.random)
        } else {
            randomHS.text = "Random Count:\n-.-"
        }
    }

    @IBAction func displayGameCenter(_ sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        present(gcVC, animated: true, completion: nil)
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
        self.dismiss(animated: true, completion: nil)
    }
}

extension HighScoresViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func submitHighScoreToGC(highScore: Double, inMode: GameMode) {
        var leaderboardID = ""
        switch inMode {
        case .upCount:
            leaderboardID = LeaderboardID.upCount.rawValue
            break
        case .downCount:
            leaderboardID = LeaderboardID.downCount.rawValue
            break
        case .random:
            leaderboardID = LeaderboardID.random.rawValue
            break
        }
        
        let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardID)
        bestScoreInt.value = Int64(highScore*100)
        
        GKScore.report([bestScoreInt], withCompletionHandler: nil)

    }
}
