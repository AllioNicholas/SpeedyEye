//
//  CountDownViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 12/06/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController {
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    var gameMode: GameMode?
    var countDownTimer: Timer = Timer()
    var countDown = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()

        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownAndStart), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownAndStart() {
        countDown -= 1
        if countDown == 0 {
            countdownLabel.text = "GO!"
        } else {
            countdownLabel.text = "\(countDown)"
        }
        if countDown == -1 {
            countDownTimer.invalidate()
            self.presentNewGameViewController()
        }
        
    }
    
    func setupUI() {
        let visualEffectView = UIVisualEffectView(frame: self.view.frame)
        visualEffectView.effect = UIBlurEffect(style: .dark)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view = visualEffectView
    }
    
    func presentNewGameViewController() {
        let gameViewController = GameViewController()
        gameViewController.gameMode = self.gameMode
        self.present(gameViewController, animated: true, completion: nil)
    }

}
