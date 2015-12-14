//
//  StartViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 08/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import UIKit
import AudioToolbox

class StartViewController: UIViewController {
    
    var navigation_buttonSound : SystemSoundID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = NSBundle.mainBundle().pathForResource("navigation_button", ofType: "wav")
        AudioServicesCreateSystemSoundID(NSURL.fileURLWithPath(filePath!), &navigation_buttonSound)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "up" {
            let vc:GameViewController = segue.destinationViewController as! GameViewController
            vc.display = 1
            vc.gameMode = GameViewController.GameMode.UpCount
        } else if segue.identifier == "down" {
            let vc:GameViewController = segue.destinationViewController as! GameViewController
            vc.display = 25
            vc.gameMode = GameViewController.GameMode.DownCount
        } else if segue.identifier == "random" {
            let vc:GameViewController = segue.destinationViewController as! GameViewController
            var num = rand() % 26
            while num == 0 {
                num = rand() % 26
            }
            vc.display = Int(num)
            vc.gameMode = GameViewController.GameMode.Random
        }
    }
    
    @IBAction func playNavigationSound(sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
    }


}

