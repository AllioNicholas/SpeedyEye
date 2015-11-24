//
//  CustomLabel.swift
//  FastEye
//
//  Created by Nicholas Allio on 12/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.numberOfLines = 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.numberOfLines = 2
    }
    
}
