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
    
    var gameMode: GameMode = .upCount
    var countDownTimer: Timer = Timer()
    var countDown = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countdownLabel.text = "\(countDown)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        countDownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (_) in
            self.countDown -= 1
            if self.countDown == 0 {
                self.countdownLabel.text = NSLocalizedString("go_txt", comment: "").uppercased()
            } else {
                self.countdownLabel.text = "\(self.countDown)"
            }
            if self.countDown == -1 {
                self.countDownTimer.invalidate()
                self.performSegue(withIdentifier: "showGame", sender: self)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        countDownTimer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? GameViewController else {
            assertionFailure("Destination segue is not GameViewController")
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        viewController.gameMode = self.gameMode
    }
}
