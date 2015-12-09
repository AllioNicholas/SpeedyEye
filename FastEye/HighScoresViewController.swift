//
//  HighScoresViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 12/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class HighScoresViewController: UIViewController {
    
    @IBOutlet weak var upHS: UILabel!
    @IBOutlet weak var downHS: UILabel!
    @IBOutlet weak var randomHS: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        if let hs = NSUserDefaults.standardUserDefaults().valueForKey("highscore_up") {
            let highscore = Double(hs as! NSNumber)
            upHS.text = NSString(format: "Up Count:\n%.2f", highscore) as String
        } else {
            upHS.text = "Up Count:\n-.-"
        }
        
        if let hs = NSUserDefaults.standardUserDefaults().valueForKey("highscore_down") {
            let highscore = Double(hs as! NSNumber)
            downHS.text = NSString(format: "Down Count:\n%.2f", highscore) as String
        } else {
            downHS.text = "Down Count:\n-.-"
        }
        
        if let hs = NSUserDefaults.standardUserDefaults().valueForKey("highscore_rand") {
            let highscore = Double(hs as! NSNumber)
            randomHS.text = NSString(format: "Random Count:\n%.2f", highscore) as String
        } else {
            randomHS.text = "Random Count:\n-.-"
        }
    }

    @IBAction func backToHome(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}