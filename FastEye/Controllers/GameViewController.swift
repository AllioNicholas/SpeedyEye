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
    
    var display: Int!
    var gameMode: GameMode!
    var takenRand = [0]
    var gameTimer: Timer = Timer()
    var elapsedTime = 0.0
    var correctCount = 0
    var highscore = Double.greatestFiniteMagnitude
   
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var cronoLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUIForNewGame()
        
        //load high score
        self.loadingScore()
    }
    
    func startCrono()  {
        //Start chrono with 0.01 precision
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.elapsedTime += 0.01
            if self.elapsedTime >= 60.0 {
                let minutes = Int(self.elapsedTime / 60)
                let secAndMill = self.elapsedTime - Double(60 * minutes)
                self.cronoLabel.text = NSString(format: "%d:%05.2f", minutes, secAndMill) as String
            } else {
                self.cronoLabel.text = NSString(format: "%.2f", self.elapsedTime) as String
            }
        })
    }
    
    func setupUIForNewGame() {
        //Setup game with according color
        let colorGame: UIColor!
        switch gameMode! {
        case .UpCount:
            display = 1
            //Viola
            colorGame = UIColor(netHex: 0x332433)
            break
        case .DownCount:
            display = 25
            //Azzurro scuro
            colorGame = UIColor(netHex: 0x4A5B82)
            break
        case .Random:
            var num = Int(arc4random_uniform(26))
            while num == 0 {
                num = Int(arc4random_uniform(26))
            }
            display = Int(num)
            //Verde acqua
            colorGame = UIColor(netHex: 0x6FA79A)
            break
        }
        
        progressBar.progress = 0.0
        progressBar.progressTintColor = colorGame
        displayLabel.text = "\(display!)"
        cronoLabel.text = "0.0"
        
        var taken = [0]
        for idx in 1...25 {
            let but = self.view.viewWithTag(idx) as! UIButton
            var lab = Int(arc4random_uniform(26))
            while taken.contains(lab) {
                lab = Int(arc4random_uniform(26))
            }
            taken.append(lab)
            but.setTitle(String(lab), for: .normal)
            but.backgroundColor = colorGame
        }
    }
    
    func loadingScore() {
        if let highScore = GameCenterManager.sharedInstance().getHighScoreForGameMode(gameMode: gameMode) {
            highScoreLabel.text = "High score: \(highScore.formatHighScore())"
        } else {
            highScoreLabel.text = "High score: -.-"
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == String(display) {
            SoundManager.sharedInstance().playCorrectSound()
            switch gameMode! {
            case .UpCount:
                correctCount += 1
                display! += 1
                gameEnded(self.gameMode)
                if display == 26 {
                    //end of the game
                    gameTimer.invalidate()
                    displayLabel.text = ""
                    progressBar.setProgress(1.0, animated: true)
                    gameEnded(.UpCount)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display!)"
                }
            case .DownCount:
                correctCount += 1
                display! -= 1
                if display == 0 {
                    //end of the game
                    gameTimer.invalidate()
                    displayLabel.text = ""
                    progressBar.setProgress(1.0, animated: true)
                    gameEnded(.DownCount)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display!)"
                }
            case .Random:
                correctCount += 1
                var num = arc4random() % 26
                while takenRand.contains(Int(num)) {
                    num = arc4random() % 26
                }
                takenRand.append(Int(num))
                display = Int(num)
                if takenRand.count == 26 {
                    //end of the game
                    gameTimer.invalidate()
                    displayLabel.text = ""
                    progressBar.setProgress(1.0, animated: true)
                    gameEnded(.Random)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display!)"
                }
            }
        } else {
            SoundManager.sharedInstance().playWrongSound()
            correctCount = 0
            progressBar.setProgress(0.0, animated: true)
            switch gameMode! {
            case .UpCount:
                display! = 1
            case .DownCount:
                display! = 25
            case .Random:
                takenRand = [0]
                var num = arc4random() % 26
                while takenRand.contains(Int(num)) {
                    num = arc4random() % 26
                }
                takenRand.append(Int(num))
                display = Int(num)
            }
            displayLabel.text = "\(display!)"
        }
    }
    
    func gameEnded(_ inMode: GameMode) {
        if self.elapsedTime < self.highscore {
            switch inMode {
            case .UpCount:
                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_up")
                break
            case .DownCount:
                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_down")
                break
            case .Random:
                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_rand")
                break
            }
        }
        self.performSegue(withIdentifier: "gameEnd", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameEnd" {
            let endViewController : EndGameViewController = segue.destination as! EndGameViewController
            
            if self.elapsedTime < self.highscore {
                endViewController.isHighscore = true
                SoundManager.sharedInstance().playRecordSound()
                GameCenterManager.sharedInstance().submitHighScoreToGameCenter(highScore: self.elapsedTime, inMode: self.gameMode)
            } else {
                endViewController.isHighscore = false
                SoundManager.sharedInstance().playEndSound()
            }
            
            endViewController.timeToDisplay = self.elapsedTime
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
