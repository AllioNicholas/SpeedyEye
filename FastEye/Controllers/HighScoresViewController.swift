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
        
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton .setTitle(NSLocalizedString("done_button_text", comment: "Done"), for: UIControl.State.normal)
        
        self.setupUI()
    }
    
    func setupUI() {
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .upCount) {
            upHS.text = NSLocalizedString("upcount", comment: "Up Count") + ":\n\(highscore.formatHighScore())"
        } else {
            upHS.text = NSLocalizedString("upcount", comment: "Up Count") + ":\n-.-"
        }
        
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .downCount) {
            downHS.text = NSLocalizedString("downcount", comment: "Down Count") + ":\n\(highscore.formatHighScore())"
        } else {
            downHS.text = NSLocalizedString("downcount", comment: "Down Count") + ":\n-.-"
        }
        
        if let highscore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: .random) {
            randomHS.text = NSLocalizedString("random", comment: "Random") + ":\n\(highscore.formatHighScore())"
        } else {
            randomHS.text = NSLocalizedString("random", comment: "Random") + ":\n-.-"
        }
    }

    @IBAction func displayGameCenter(_ sender: UIButton) {
        SoundManager.sharedInstance().playNavigationSound()
        let leaderboardViewController = GameCenterManager
                                        .sharedInstance()
                                        .getGameCenterLeaderboardViewController()
        present(leaderboardViewController, animated: true, completion: nil)
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        SoundManager.sharedInstance().playNavigationSound()
        self.dismiss(animated: true, completion: nil)
    }
}
