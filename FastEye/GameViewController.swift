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
import AudioToolbox
import GameKit

enum GameMode {
    case upCount
    case downCount
    case random
}

class GameViewController: UIViewController {
    
    var display: Int!
    var gameMode: GameMode!
    var takenRand = [0]
    var gameTimer: Timer = Timer()
    var countDownTimer: Timer = Timer()
    var elapsedTime = 0.0
    var countDown = 3
    var countdownLabel: UILabel!
    var correctCount = 0
    var highscore = DBL_MAX
    
    var navigation_buttonSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 1
    var wrongSound: SystemSoundID = 2
    var end_gameSound: SystemSoundID = 3
    var new_recordSound:  SystemSoundID = 4
   
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var cronoLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var prog2: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Correct button pressed
        var filePath = Bundle.main.path(forResource: "Correct", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &correctSound)
        
        //Wronf button pressed
        filePath = Bundle.main.path(forResource: "Fail", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &wrongSound)
        
        //Game ended with no new record
        filePath = Bundle.main.path(forResource: "ending_sound", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &end_gameSound)
        
        //Game ended with new record
        filePath = Bundle.main.path(forResource: "new_record", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &new_recordSound)
        
        //Navigation button
        filePath = Bundle.main.path(forResource: "navigation_button", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &navigation_buttonSound)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Prepare countdown before game
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let cdView = Bundle.main.loadNibNamed("CountdownView", owner: self, options: nil)?[0] as! UIView
//        let cdView = array.object(at: 0) as! UIView
        countdownLabel = cdView.viewWithTag(1) as! UILabel
        countdownLabel.text = "3"
        
        cdView.frame = self.view.bounds

        blurEffectView.addSubview(cdView)
        
        self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.updateCountdownAndStart), userInfo: nil, repeats: true)
        
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
            but.setTitle(String(lab), for: UIControlState())
            but.backgroundColor = colorGame
        }
        
        //load high score
        switch gameMode! {
        case .upCount:
            if let hs = UserDefaults.standard.value(forKey: "highscore_up") {
                highscore = Double(hs as! NSNumber)
                highScoreLabel.text = NSString(format: "High score: %.2f", highscore) as String
            } else {
                highScoreLabel.text = "High score: 0.0"
            }
        case .downCount:
            if let hs = UserDefaults.standard.value(forKey: "highscore_down") {
                highscore = Double(hs as! NSNumber)
                highScoreLabel.text = NSString(format: "High score: %.2f", highscore) as String
            } else {
                highScoreLabel.text = "High score: 0.0"
            }
        case .random:
            if let hs = UserDefaults.standard.value(forKey: "highscore_rand") {
                highscore = Double(hs as! NSNumber)
                highScoreLabel.text = NSString(format: "High score: %.2f", highscore) as String
                takenRand.append(display)
            } else {
                highScoreLabel.text = "High score: 0.0"
            }
        }
        
        
    }
    
    func updateTime() {
        elapsedTime += 0.01
        cronoLabel.text = NSString(format: "%.2f", elapsedTime) as String
    }
    
    func updateCountdownAndStart() {
        countDown -= 1
        if countDown == 0 {
            countdownLabel.text = "GO!"
        } else {
            countdownLabel.text = String(countDown)
        }
        if countDown == -1 {
            countDownTimer.invalidate()
            //Start chrono with 0.01 precision
            gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(GameViewController.updateTime), userInfo: nil, repeats: true)
            self.view.subviews.last!.removeFromSuperview()
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
    
    func displayScore(_ isHighScore: Bool, withTime: Double, inMode: GameMode) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let endView = Bundle.main.loadNibNamed("EndGameView", owner: self, options: nil)?[0] as! UIView
        
        //Customization endView according to the result and the game mode
        //Main label (tag 10)
        let mainLabel = endView.viewWithTag(10) as! UILabel
        //Game mode label (tag 11)
        let modeLabel = endView.viewWithTag(11) as! UILabel
        modeLabel.text = "Mode \(inMode)"
        //Time label (tag 12)
        let timeLabel = endView.viewWithTag(12) as! UILabel
        
        if isHighScore {
            mainLabel.text = "New Record!"
            timeLabel.text = NSString(format: "New best time: %.2f s", withTime) as String
            AudioServicesPlaySystemSound(new_recordSound)
            submitHighScoreToGC(highScore: withTime, inMode: inMode)
        } else {
            mainLabel.text = "Too slow!"
            timeLabel.text = NSString(format: "Your time: %.2f s", withTime) as String
            AudioServicesPlaySystemSound(end_gameSound)
        }
        
        //Back button (tag 13)
        let backButton = endView.viewWithTag(13) as! UIButton
        backButton.addTarget(self, action: #selector(GameViewController.dismissEndView), for: UIControlEvents.touchUpInside)
        
        
        endView.frame = self.view.bounds
        
        blurEffectView.addSubview(endView)
                        
        self.view.addSubview(blurEffectView)
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func dismissEndView() {
        AudioServicesPlaySystemSound(navigation_buttonSound)
        _ = self.navigationController?.popToRootViewController(animated: true)
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
