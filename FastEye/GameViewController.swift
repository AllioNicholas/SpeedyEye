//
//  GameViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 08/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import UIKit
import Foundation

class GameViewController: UIViewController {
    
    enum GameMode {
        case UpCount
        case DownCount
        case Random
    }
    
    var display: Int!
    var gameMode: GameMode!
    var takenRand = [0]
    var timer: NSTimer = NSTimer()
    var elapsedTime = 0.0
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var cronoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //Start chrono with 0.01 precision
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        displayLabel.text = "\(display)"
        cronoLabel.text = "0.0"
        var taken = [0]
        for idx in 1...25 {
            let but = self.view.viewWithTag(idx) as! UIButton
            var lab = Int(rand() % 26)
            while taken.contains(lab) {
                lab = Int(rand() % 26)
            }
            taken.append(lab)
            but.setTitle(String(lab), forState: UIControlState.Normal)
        }
    }
    
    func updateTime() {
        elapsedTime += 0.01
        cronoLabel.text = NSString(format: "%.2f", elapsedTime) as String
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        if sender.titleLabel?.text == String(display) {
            switch gameMode! {
            case .UpCount:
                display!++
                if display == 26 {
                    //end of the game
                    timer.invalidate()
                    displayLabel.text = ""
                } else {
                    displayLabel.text = "\(display)"
                }
            case .DownCount:
                display!--
                if display == 0 {
                    //end of the game
                    timer.invalidate()
                    displayLabel.text = ""
                } else {
                    displayLabel.text = "\(display)"
                }
            case .Random:
                var num = rand() % 26
                while takenRand.contains(Int(num)) {
                    num = rand() % 26
                }
                display = Int(num)
                if takenRand.count == 26 {
                    //end of the game
                    timer.invalidate()
                    displayLabel.text = ""
                } else {
                    displayLabel.text = "\(display)"
                }
            }
        }
    }
    
}