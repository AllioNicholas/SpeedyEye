//
//  EndGameViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 25/09/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var finalTimeLabel: UILabel!
    
    var dismissalBlock: (() -> Void)?
    var gameMode: GameMode!
    var timeToDisplay: Double!
    var isHighscore: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.modeLabel.text = "Mode \(self.gameMode!.rawValue)"
        
        if self.isHighscore {
            self.mainTitleLabel.text = "New Record!"
            self.finalTimeLabel.text = NSString(format: "New best time: %.2f s", self.timeToDisplay) as String
        } else {
            self.mainTitleLabel.text = "Too slow!"
            self.finalTimeLabel.text = NSString(format: "Your time: %.2f s", self.timeToDisplay) as String
        }
    }

    @IBAction func backHomeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: self.dismissalBlock)
    }
    
}
