//
//  GameManager.swift
//  FastEye
//
//  Created by Nicholas Allio on 25/09/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit

enum GameMode : String {
    case UpCount
    case DownCount
    case Random
    
    // MARK: - Initializers
    
    init?(fullType: String) {
        guard let last = fullType.components(separatedBy: ".").last else { return nil }
        
        self.init(rawValue: last)
    }
}

class GameManager: NSObject {
    
}
