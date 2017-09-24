//
//  EndGameView.swift
//  FastEye
//
//  Created by Nicholas Allio on 12/06/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

class EndGameView: UIVisualEffectView {
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var finalTimeLabel: UILabel!
    
    
    convenience init(frame: CGRect) {
        self.init()
        
        self.frame = frame
        self.effect = UIBlurEffect(style: .dark)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
    }
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
