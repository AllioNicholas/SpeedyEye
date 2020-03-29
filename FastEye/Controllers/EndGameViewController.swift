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
        
        if self.isHighscore {
            self.mainTitleLabel.text = NSLocalizedString("new_record", comment: "")
            self.finalTimeLabel.text = NSString(
                format: NSLocalizedString("new_best_time_%f", comment: "") as NSString,
                self.timeToDisplay) as String
        } else {
            self.mainTitleLabel.text = NSLocalizedString("too_slow", comment: "")
            self.finalTimeLabel.text = NSString(
            format: NSLocalizedString("your_time_%f", comment: "") as NSString,
            self.timeToDisplay) as String
        }
    }
    
    private func bindMode() {
        guard let gameMode = gameMode else { return }
        switch gameMode {
        case .upCount:
            self.modeLabel.text = "Mode " + NSLocalizedString("upcount", comment: "")
        case .downCount:
            self.modeLabel.text = "Mode " + NSLocalizedString("downcount", comment: "")
        case .random:
            self.modeLabel.text = "Mode " + NSLocalizedString("random", comment: "")
        }
    }

    @IBAction func backHomeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: self.dismissalBlock)
    }
    
}
