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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let filePath = Bundle.main.path(forResource: "navigation_button", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &navigation_buttonSound)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "up" {
            let vc:GameViewController = segue.destination as! GameViewController
            vc.display = 1
            vc.gameMode = GameViewController.GameMode.upCount
        } else if segue.identifier == "down" {
            let vc:GameViewController = segue.destination as! GameViewController
            vc.display = 25
            vc.gameMode = GameViewController.GameMode.downCount
        } else if segue.identifier == "random" {
            let vc:GameViewController = segue.destination as! GameViewController
            var num = Int(arc4random_uniform(26))
            while num == 0 {
                num = Int(arc4random_uniform(26))
            }
            vc.display = Int(num)
            vc.gameMode = GameViewController.GameMode.random
        }
    }
    
    @IBAction func playNavigationSound(_ sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
    }


}

