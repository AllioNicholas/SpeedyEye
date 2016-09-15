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

class HighScoresViewController: UIViewController {
    
    @IBOutlet weak var upHS: UILabel!
    @IBOutlet weak var downHS: UILabel!
    @IBOutlet weak var randomHS: UILabel!
    
    var navigation_buttonSound : SystemSoundID = 0
    
    override func viewDidLoad() {
        let filePath = Bundle.main.path(forResource: "navigation_button", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &navigation_buttonSound)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let hs = UserDefaults.standard.value(forKey: "highscore_up") {
            let highscore = Double(hs as! NSNumber)
            upHS.text = NSString(format: "Up Count:\n%.2f", highscore) as String
        } else {
            upHS.text = "Up Count:\n-.-"
        }
        
        if let hs = UserDefaults.standard.value(forKey: "highscore_down") {
            let highscore = Double(hs as! NSNumber)
            downHS.text = NSString(format: "Down Count:\n%.2f", highscore) as String
        } else {
            downHS.text = "Down Count:\n-.-"
        }
        
        if let hs = UserDefaults.standard.value(forKey: "highscore_rand") {
            let highscore = Double(hs as! NSNumber)
            randomHS.text = NSString(format: "Random Count:\n%.2f", highscore) as String
        } else {
            randomHS.text = "Random Count:\n-.-"
        }
    }

    @IBAction func backToHome(_ sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
        self.dismiss(animated: true, completion: nil)
    }
}
