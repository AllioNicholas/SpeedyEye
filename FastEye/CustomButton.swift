//
//  CustomButton.swift
//  FastEye
//
//  Created by Nicholas Allio on 09/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.titleLabel!.font = UIFont(name: "Candara", size: 20)
        self.titleLabel!.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.titleLabel!.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
}
