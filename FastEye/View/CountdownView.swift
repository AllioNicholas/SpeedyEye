//
//  CountdownView.swift
//  FastEye
//
//  Created by Nicholas Allio on 11/06/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

class CountdownView: UIVisualEffectView {

    @IBOutlet weak var countdownLabel: UILabel!
    
    convenience init(frame: CGRect) {
        self.init()
        
        self.frame = frame
        self.effect = UIBlurEffect(style: .dark)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.countdownLabel.text = "3"
        
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
