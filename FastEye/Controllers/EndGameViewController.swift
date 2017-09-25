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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
