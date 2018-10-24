//
//  StartViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 08/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var downcountButton: UIButton!
    @IBOutlet weak var upcountButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var highscoresButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upcountButton.setTitle(NSLocalizedString("upcount_mode", comment: "button title"), for: UIControl.State.normal)
        downcountButton.setTitle(NSLocalizedString("downcount_mode", comment: "button title"), for: UIControl.State.normal)
        randomButton.setTitle(NSLocalizedString("random_mode", comment: "button title"), for: UIControl.State.normal)
        highscoresButton.setTitle(NSLocalizedString("highscores", comment: "button title"), for: UIControl.State.normal)
        
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

