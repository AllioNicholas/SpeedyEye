//
//  StartViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 08/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import UIKit
import AudioToolbox
import GameKit

class StartViewController: UIViewController {

    var navigation_buttonSound: SystemSoundID = 0
    
    var gcEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateGCUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let filePath = Bundle.main.path(forResource: "navigation_button", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &navigation_buttonSound)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "up" {
            let vc:GameViewController = segue.destination as! GameViewController
            vc.display = 1
            vc.gameMode = GameMode.upCount
        } else if segue.identifier == "down" {
            let vc:GameViewController = segue.destination as! GameViewController
            vc.display = 25
            vc.gameMode = GameMode.downCount
        } else if segue.identifier == "random" {
            let vc:GameViewController = segue.destination as! GameViewController
            var num = Int(arc4random_uniform(26))
            while num == 0 {
                num = Int(arc4random_uniform(26))
            }
            vc.display = Int(num)
            vc.gameMode = GameMode.random
        }
    }
    
    @IBAction func playNavigationSound(_ sender: UIButton) {
        AudioServicesPlaySystemSound(navigation_buttonSound)
    }
}

extension StartViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticateGCUser() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(vc, error) -> Void in
            if vc != nil {
                // 1. Show login if player is not logged in
                self.present(vc!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error ?? "")
            }
        }
    }
}

