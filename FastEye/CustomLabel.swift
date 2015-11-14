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
        self.font = UIFont(name: "Candara", size: 20)
        self.numberOfLines = 2
        self.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.font = UIFont(name: "Candara", size: 20)
        self.numberOfLines = 2
        self.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
}
