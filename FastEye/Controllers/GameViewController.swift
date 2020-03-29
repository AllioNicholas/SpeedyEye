//
//  GameViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 08/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Darwin
import CoreGraphics

class GameViewController: UIViewController {
    
    var correctCount = 0

    var gameManager: GameManager = GameManager()
    var gameMode: GameMode = .upCount

    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var cronoLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNewGame()

        //load high score
        self.loadingScore()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.gameManager.startGame()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.gameManager.stopTimer()
    }

    func setupNewGame() {
        //Setup game with according color
        self.gameManager = GameManager(gameMode: self.gameMode, initialSetup: { [weak self] (setup) in
            guard let colorGame = setup[kGameColor] as? UIColor,
                    let initialValue = setup[kGameInitialValue] as? Int else {
                assertionFailure("Error initializing game with color and initial value")
                self?.navigationController?.popToRootViewController(animated: true)
                return
            }

            self?.correctCount = 0
            self?.progressBar.progress = 0.0
            self?.progressBar.progressTintColor = colorGame
            self?.displayLabel.text = "\(initialValue)"
            self?.cronoLabel.text = "0.0"

            var taken = [0]
            for idx in 1...25 {
                guard let but = self?.view.viewWithTag(idx) as? UIButton else {
                    assertionFailure("View tagged with idx \(idx) is not a button")
                    self?.navigationController?.popToRootViewController(animated: true)
                    return
                }
                var lab = Int(arc4random_uniform(26))
                while taken.contains(lab) {
                    lab = Int(arc4random_uniform(26))
                }
                taken.append(lab)
                but.setTitle(String(lab), for: .normal)
                but.backgroundColor = colorGame
            }
        })

        self.gameManager.timeUpdateBlock = { [weak self] (timeString) in
            self?.cronoLabel.text = timeString
        }
    }

    func loadingScore() {
        if let highScore = GameCenterManager.shared.getHighScoreForGameMode(gameMode) {
            highScoreLabel.text = "High score: \(highScore.formatHighScore())"
        } else {
            highScoreLabel.text = "High score: -.-"
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        let stringNumberSelected = sender.titleLabel?.text
        guard let numberSelected = NumberFormatter().number(from: stringNumberSelected!) else { return }
        let (finished, correct, nextValue) = self.gameManager.didSelectValue(value: numberSelected.intValue)
        if correct {
            SoundManager.sharedInstance().playCorrectSound()
            self.correctCount += 1

            if finished {
                //end of the game
                self.displayLabel.text = ""
                self.progressBar.setProgress(1.0, animated: true)

                gameEnded(self.gameMode)
            } else {
                self.progressBar.setProgress(Float(self.correctCount)/25.0, animated: true)
                self.displayLabel.text = "\(nextValue)"
            }

        } else {
            SoundManager.sharedInstance().playWrongSound()
            self.correctCount = 0
            self.progressBar.setProgress(0.0, animated: true)
            self.displayLabel.text = "\(nextValue)"
        }
    }

    func gameEnded(_ inMode: GameMode) {
        self.performSegue(withIdentifier: "gameEnd", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameEnd" {
            guard let endViewController = segue.destination as? EndGameViewController else {
                assertionFailure("Destination segue is not EndGameViewController")
                self.navigationController?.popToRootViewController(animated: true)
                return
            }

            if self.gameManager.isHighScore() {
                endViewController.isHighscore = true
                SoundManager.sharedInstance().playRecordSound()
            } else {
                endViewController.isHighscore = false
                SoundManager.sharedInstance().playEndSound()
            }

            if let finalTime = self.gameManager.finalTime() {
                endViewController.timeToDisplay = finalTime
            }
            endViewController.gameMode = self.gameMode
            endViewController.dismissalBlock = {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    @IBAction func backButton(_ sender: UIButton) {
        SoundManager.sharedInstance().playNavigationSound()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    func dismissEndView() {
        SoundManager.sharedInstance().playNavigationSound()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
