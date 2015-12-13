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

class GameViewController: UIViewController {
    
    enum GameMode {
        case UpCount
        case DownCount
        case Random
    }
    
    var display: Int!
    var gameMode: GameMode!
    var takenRand = [0]
    var gameTimer: NSTimer = NSTimer()
    var countDownTimer: NSTimer = NSTimer()
    var elapsedTime = 0.0
    var countDown = 3
    var countdownLabel: UILabel!
    var correctCount = 0
    var highscore = DBL_MAX
    
    var correctSound : SystemSoundID = 0
    var wrongSound : SystemSoundID = 1
   
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var cronoLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var prog2: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var filePath = NSBundle.mainBundle().pathForResource("Correct", ofType: "wav")
        AudioServicesCreateSystemSoundID(NSURL.fileURLWithPath(filePath!), &correctSound)
        
        filePath = NSBundle.mainBundle().pathForResource("Fail", ofType: "wav")
        AudioServicesCreateSystemSoundID(NSURL.fileURLWithPath(filePath!), &wrongSound)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //Prepare countdown before game
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let array = NSBundle.mainBundle().loadNibNamed("CountdownView", owner: self, options: nil) as NSArray
        let cdView = array.objectAtIndex(0) as! UIView
        countdownLabel = cdView.viewWithTag(1) as! UILabel
        countdownLabel.text = "3"
        
        cdView.frame = self.view.bounds

        blurEffectView.addSubview(cdView)
        
        self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCountdownAndStart"), userInfo: nil, repeats: true)
        
        //Setup game with according color
        let colorGame: UIColor!
        switch gameMode! {
        case .UpCount:
            //Viola
            colorGame = UIColor(netHex: 0x332433)
        case .DownCount:
            //Azzurro scuro
            colorGame = UIColor(netHex: 0x4A5B82)
        case .Random:
            //Verde acqua
            colorGame = UIColor(netHex: 0x6FA79A)
        }
        
        progressBar.progress = 0.0
        progressBar.progressTintColor = colorGame
        prog2.progress = 0.0
        prog2.progressTintColor = colorGame
        displayLabel.text = "\(display)"
        cronoLabel.text = "0.0"
        var taken = [0]
        for idx in 1...25 {
            let but = self.view.viewWithTag(idx) as! UIButton
            var lab = Int(arc4random_uniform(26))
            while taken.contains(lab) {
                lab = Int(arc4random_uniform(26))
            }
            taken.append(lab)
            but.setTitle(String(lab), forState: UIControlState.Normal)
            but.backgroundColor = colorGame
        }
        
        //load high score
        switch gameMode! {
        case .UpCount:
            if let hs = NSUserDefaults.standardUserDefaults().valueForKey("highscore_up") {
                highscore = Double(hs as! NSNumber)
                highScoreLabel.text = NSString(format: "High score: %.2f", highscore) as String
            } else {
                highScoreLabel.text = "High score: 0.0"
            }
        case .DownCount:
            if let hs = NSUserDefaults.standardUserDefaults().valueForKey("highscore_down") {
                highscore = Double(hs as! NSNumber)
                highScoreLabel.text = NSString(format: "High score: %.2f", highscore) as String
            } else {
                highScoreLabel.text = "High score: 0.0"
            }
        case .Random:
            if let hs = NSUserDefaults.standardUserDefaults().valueForKey("highscore_rand") {
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
        countDown--
        if countDown == 0 {
            countdownLabel.text = "GO!"
        } else {
            countdownLabel.text = String(countDown)
        }
        if countDown == -1 {
            countDownTimer.invalidate()
            //Start chrono with 0.01 precision
            gameTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
            self.view.subviews.last!.removeFromSuperview()
        }
        
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        if sender.titleLabel?.text == String(display) {
            AudioServicesPlaySystemSound(correctSound)
            switch gameMode! {
            case .UpCount:
                correctCount++
                display!++
                if display == 26 {
                    //end of the game
                    gameTimer.invalidate()
                    displayLabel.text = ""
                    progressBar.setProgress(1.0, animated: true)
                    prog2.setProgress(1.0, animated: true)
                    gameEnded(.UpCount)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    prog2.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display)"
                }
            case .DownCount:
                correctCount++
                display!--
                if display == 0 {
                    //end of the game
                    gameTimer.invalidate()
                    displayLabel.text = ""
                    progressBar.setProgress(1.0, animated: true)
                    prog2.setProgress(1.0, animated: true)
                    gameEnded(.DownCount)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    prog2.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display)"
                }
            case .Random:
                correctCount++
                var num = rand() % 26
                while takenRand.contains(Int(num)) {
                    num = rand() % 26
                }
                takenRand.append(Int(num))
                display = Int(num)
                if takenRand.count == 26 {
                    //end of the game
                    gameTimer.invalidate()
                    displayLabel.text = ""
                    progressBar.setProgress(1.0, animated: true)
                    prog2.setProgress(1.0, animated: true)
                    gameEnded(.Random)
                } else {
                    progressBar.setProgress(Float(correctCount)/25.0, animated: true)
                    prog2.setProgress(Float(correctCount)/25.0, animated: true)
                    displayLabel.text = "\(display)"
                }
            }
        } else {
            AudioServicesPlaySystemSound(wrongSound)
            correctCount = 0
            progressBar.setProgress(0.0, animated: true)
            prog2.setProgress(0.0, animated: true)
            switch gameMode! {
            case .UpCount:
                display! = 1
            case .DownCount:
                display! = 25
            case .Random:
                takenRand = [0]
                var num = rand() % 26
                while takenRand.contains(Int(num)) {
                    num = rand() % 26
                }
                takenRand.append(Int(num))
                display = Int(num)
            }
            displayLabel.text = "\(display)"
        }
    }
    
    func gameEnded(inMode: GameMode) {
        switch inMode {
        case .UpCount:
            if elapsedTime < highscore {
                NSUserDefaults.standardUserDefaults().setValue(elapsedTime, forKey: "highscore_up")
                displayScore(true, withTime: elapsedTime, inMode: inMode)
                highScoreLabel.text = NSString(format: "High score: %.2f", elapsedTime) as String
            } else {
                displayScore(false, withTime: elapsedTime, inMode: inMode)
            }
        case .DownCount:
            if elapsedTime < highscore {
                NSUserDefaults.standardUserDefaults().setValue(elapsedTime, forKey: "highscore_down")
                displayScore(true, withTime: elapsedTime, inMode: inMode)
                highScoreLabel.text = NSString(format: "High score: %.2f", elapsedTime) as String
            } else {
                displayScore(false, withTime: elapsedTime, inMode: inMode)
            }
        case .Random:
            if elapsedTime < highscore {
                NSUserDefaults.standardUserDefaults().setValue(elapsedTime, forKey: "highscore_rand")
                displayScore(true, withTime: elapsedTime, inMode: inMode)
                highScoreLabel.text = NSString(format: "High score: %.2f", elapsedTime) as String
            } else {
                displayScore(false, withTime: elapsedTime, inMode: inMode)
            }
        }
        
    }
    
    func displayScore(isHighScore: Bool, withTime: Double, inMode: GameMode) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let array = NSBundle.mainBundle().loadNibNamed("EndGameView", owner: self, options: nil) as NSArray
        let endView = array.objectAtIndex(0) as! UIView
        
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
        } else {
            mainLabel.text = "Too slow!"
            timeLabel.text = NSString(format: "Your time: %.2f s", withTime) as String
        }
        
        //Back button (tag 13)
        let backButton = endView.viewWithTag(13) as! UIButton
        backButton.addTarget(self, action: Selector("dismissEndView"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        endView.frame = self.view.bounds
        
        blurEffectView.addSubview(endView)
                        
        self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func dismissEndView() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}