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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .UpCount) {
            upHS.text = "Up Count:\n\(highscore.formatHighScore())"
        } else {
            upHS.text = "Up Count:\n-.-"
        }
        
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .DownCount) {
            downHS.text = "Down Count:\n\(highscore.formatHighScore())"
        } else {
            downHS.text = "Down Count:\n-.-"
        }
        
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .Random) {
            randomHS.text = "Random Count:\n\(highscore.formatHighScore())"
        } else {
            randomHS.text = "Random Count:\n-.-"
        }
    }

    @IBAction func displayGameCenter(_ sender: UIButton) {
        SoundManager.sharedInstance().playNavigationSound()
        let leaderboardViewController = GameCenterManager.sharedInstance().getGameCenterLeaderboardViewController()
        present(leaderboardViewController, animated: true, completion: nil)
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        SoundManager.sharedInstance().playNavigationSound()
        self.dismiss(animated: true, completion: nil)
    }
}
