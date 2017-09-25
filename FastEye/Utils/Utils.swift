//
//  Utils.swift
//  FastEye
//
//  Created by Nicholas Allio on 25/09/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

class Utils: NSObject {

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension Double {
    func formatHighScore() -> String {
        if self >= 60.0 {
            let minutes = Int(self / 60)
            let secAndMill = self - Double(60 * minutes)
            return NSString(format: "%d:%05.2f", minutes, secAndMill) as String
        } else {
            return NSString(format: "%.2f", self) as String
        }
    }
}
