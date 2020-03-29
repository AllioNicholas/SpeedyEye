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
        
        upcountButton.setTitle(NSLocalizedString("upcount_mode",
                                                 comment: "button title"),
                               for: UIControl.State.normal)
        downcountButton.setTitle(NSLocalizedString("downcount_mode",
                                                   comment: "button title"),
                                 for: UIControl.State.normal)
        randomButton.setTitle(NSLocalizedString("random_mode",
                                                comment: "button title"),
                              for: UIControl.State.normal)
        highscoresButton.setTitle(NSLocalizedString("highscores",
                                                    comment: "button title"),
                                  for: UIControl.State.normal)
        
        weak var weakSelf = self
        GameCenterManager.shared.authenticateGameCenterUser(
            successBlockOrViewController: { (success, viewController) in
                if !success, let viewController = viewController {
                    weakSelf!.present(viewController, animated: true, completion: nil)
                }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayHighScores" {
            
        } else {
            guard let viewController = segue.destination as? CountDownViewController else {
                assertionFailure("Destination segue is not CountDownViewController")
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            if segue.identifier == "upcount" {
                viewController.gameMode = .upCount
            } else if segue.identifier == "downcount" {
                viewController.gameMode = .downCount
            } else if segue.identifier == "random" {
                viewController.gameMode = .random
            }
        }
    }
    
    @IBAction func playNavigationSound(_ sender: UIButton) {
        SoundManager.shared.playNavigationSound()
    }
}
