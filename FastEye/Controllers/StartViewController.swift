//
//  StartViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 08/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self
        GameCenterManager.sharedInstance().authenticateGameCenterUser(successBlockOrViewController: { (success, viewController) in
            if !success, let vc = viewController {
                weakSelf!.present(vc, animated: true, completion: nil)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayHighScores" {
            
        } else {
            let vc:CountDownViewController = segue.destination as! CountDownViewController
            if segue.identifier == "upcount" {
                vc.gameMode = .UpCount
            } else if segue.identifier == "downcount" {
                vc.gameMode = .DownCount
            } else if segue.identifier == "random" {
                vc.gameMode = .Random
            }
        }
    }
    
    @IBAction func playNavigationSound(_ sender: UIButton) {
        SoundManager.sharedInstance().playNavigationSound()
    }
}

