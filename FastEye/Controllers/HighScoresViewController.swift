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
    
    @IBOutlet weak private var upHS: UILabel!
    @IBOutlet weak private var downHS: UILabel!
    @IBOutlet weak private var randomHS: UILabel!
    @IBOutlet weak private var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.setTitle(NSLocalizedString("done_button_text", comment: "Done"),
                            for: UIControl.State.normal)
        
        setupUI()
    }
    
    private func setupUI() {
        if let highscore = GameCenterManager.shared.getHighScoreForGameMode(.upCount) {
            upHS.text = NSLocalizedString("upcount", comment: "Up Count") +
            ":\n\(highscore.formattedHighScore)"
        } else {
            upHS.text = NSLocalizedString("upcount", comment: "Up Count") + ":\n-.-"
        }
        
        if let highscore = GameCenterManager.shared.getHighScoreForGameMode(.downCount) {
            downHS.text = NSLocalizedString("downcount", comment: "Down Count") +
            ":\n\(highscore.formattedHighScore)"
        } else {
            downHS.text = NSLocalizedString("downcount", comment: "Down Count") + ":\n-.-"
        }
        
        if let highscore = GameCenterManager.shared.getHighScoreForGameMode(.random) {
            randomHS.text = NSLocalizedString("random", comment: "Random") +
            ":\n\(highscore.formattedHighScore)"
        } else {
            randomHS.text = NSLocalizedString("random", comment: "Random") + ":\n-.-"
        }
    }

    @IBAction private func displayGameCenter(_ sender: UIButton) {
        SoundManager.shared.playNavigationSound()
        let leaderboardViewController = GameCenterManager
                                        .shared
                                        .leaderboardViewController
        present(leaderboardViewController, animated: true, completion: nil)
    }
    
    @IBAction private func backToHome(_ sender: UIButton) {
        SoundManager.shared.playNavigationSound()
        self.dismiss(animated: true, completion: nil)
    }
}
