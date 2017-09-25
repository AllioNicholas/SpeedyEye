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
    @IBOutlet weak var prog2: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUIForNewGame()
        
        //load high score
        self.loadingScore()
    }
    
    func startCrono()  {
        //Start chrono with 0.01 precision
        gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        elapsedTime += 0.01
        if elapsedTime >= 60.0 {
            let minutes = Int(elapsedTime / 60)
            let secAndMill = elapsedTime - Double(60 * minutes)
            cronoLabel.text = NSString(format: "%d:%05.2f", minutes, secAndMill) as String
        } else {
            cronoLabel.text = NSString(format: "%.2f", elapsedTime) as String
        }
    }
    
    func setupUIForNewGame() {
        //Setup game with according color
        let colorGame: UIColor!
        switch gameMode! {
        case .upCount:
            //Viola
            colorGame = UIColor(netHex: 0x332433)
        case .downCount:
            //Azzurro scuro
            colorGame = UIColor(netHex: 0x4A5B82)
        case .random:
            //Verde acqua
            colorGame = UIColor(netHex: 0x6FA79A)
        }
        
        progressBar.progress = 0.0
        progressBar.progressTintColor = colorGame
        prog2.progress = 0.0
        prog2.progressTintColor = colorGame
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
            AudioServicesPlaySystemSound(correctSound)
            switch gameMode! {
            case .upCount:
                correctCount += 1
                display! += 1
                if display == 26 {
                    //end of the game
                    gameTimer.invalidate()
                    displayLabel.text = ""
                    progressBar.setProgress(1.0, animated: true)
                    prog2.setProgress(1.0, animated: true)
                    gameEnded(.upCount)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    prog2.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display!)"
                }
            case .downCount:
                correctCount += 1
                display! -= 1
                if display == 0 {
                    //end of the game
                    gameTimer.invalidate()
                    displayLabel.text = ""
                    progressBar.setProgress(1.0, animated: true)
                    prog2.setProgress(1.0, animated: true)
                    gameEnded(.downCount)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    prog2.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display!)"
                }
            case .random:
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
                    prog2.setProgress(1.0, animated: true)
                    gameEnded(.random)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    prog2.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display!)"
                }
            }
        } else {
            AudioServicesPlaySystemSound(wrongSound)
            correctCount = 0
            progressBar.setProgress(0.0, animated: true)
            prog2.setProgress(0.0, animated: true)
            switch gameMode! {
            case .upCount:
                display! = 1
            case .downCount:
                display! = 25
            case .random:
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
        if elapsedTime < highscore {
            switch inMode {
            case .upCount:
                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_up")
                displayScore(true, withTime: elapsedTime, inMode: inMode)
                highScoreLabel.text = NSString(format: "High score: %.2f", elapsedTime) as String
                break
            case .downCount:
                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_down")
                displayScore(true, withTime: elapsedTime, inMode: inMode)
                highScoreLabel.text = NSString(format: "High score: %.2f", elapsedTime) as String
                break
            case .random:
                UserDefaults.standard.setValue(elapsedTime, forKey: "highscore_rand")
                displayScore(true, withTime: elapsedTime, inMode: inMode)
                highScoreLabel.text = NSString(format: "High score: %.2f", elapsedTime) as String
                break
            }
        } else {
            displayScore(false, withTime: elapsedTime, inMode: inMode)
        }
    }
    
    func displayScore(_ isHighScore: Bool, withTime time: Double, inMode mode: GameMode) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if let endViewController = storyboard.instantiateViewController(withIdentifier: "EndViewController") as? EndGameViewController {
        
            //Customization endView according to the result and the game mode
            endViewController.modeLabel.text = "Mode \(mode)"
            
            if isHighScore {
                endViewController.mainTitleLabel.text = "New Record!"
                endViewController.finalTimeLabel.text = NSString(format: "New best time: %.2f s", time) as String
                SoundManager.sharedInstance().playRecordSound()
                GameCenterManager.sharedInstance().submitHighScoreToGameCenter(highScore: time, inMode: mode)
            } else {
                endViewController.mainTitleLabel.text = "Too slow!"
                endViewController.finalTimeLabel.text = NSString(format: "Your time: %.2f s", time) as String
                SoundManager.sharedInstance().playEndSound()
            }
            
            self.present(endViewController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        SoundManager.sharedInstance().playNavigationSound()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dismissEndView() {
        SoundManager.sharedInstance().playNavigationSound()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
}
