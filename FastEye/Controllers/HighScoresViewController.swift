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
    
    private var navigation_buttonSound : SystemSoundID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = Bundle.main.path(forResource: "navigation_button", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &navigation_buttonSound)
        
        setupUI()
    }
    
    func setupUI() {
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .upCount) {
            upHS.text = "Up Count:\n\(formatHighScore(highScore: highscore))"
        } else {
            upHS.text = "Up Count:\n-.-"
        }
        
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .downCount) {
            downHS.text = "Down Count:\n\(formatHighScore(highScore: highscore))"
        } else {
            downHS.text = "Down Count:\n-.-"
        }
        
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .random) {
            randomHS.text = "Random Count:\n\(formatHighScore(highScore: highscore))"
        } else {
            randomHS.text = "Random Count:\n-.-"
        }
    }
    
    func formatHighScore(highScore: Double) -> String {
        if highScore >= 60.0 {
            let minutes = Int(highScore / 60)
            let secAndMill = highScore - Double(60 * minutes)
            return NSString(format: "%d:%05.2f", minutes, secAndMill) as String
        } else {
            return NSString(format: "%.2f", highScore) as String
        }
    }

    @IBAction func displayGameCenter(_ sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
        let leaderboardViewController = GameCenterManager.sharedInstance().getGameCenterLeaderboardViewController()
        present(leaderboardViewController, animated: true, completion: nil)
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
        self.dismiss(animated: true, completion: nil)
    }
}
