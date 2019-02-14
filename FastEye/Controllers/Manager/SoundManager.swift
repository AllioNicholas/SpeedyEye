//
//  SoundManager.swift
//  FastEye
//
//  Created by Nicholas Allio on 25/09/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit
import AudioToolbox

let kUserDefaultAudioDisabledKey = "UserDefaultAudioDisabledKey"

class SoundManager: NSObject {

    static private var _sharedInstance: SoundManager!
    
    private var isSoundDisabled: Bool = false
    
    private var sFastEyeSoundNavigation: SystemSoundID = 0
    private var sFastEyeSoundCorrect: SystemSoundID = 1
    private var sFastEyeSoundWrong: SystemSoundID = 2
    private var sFastEyeSoundEnd: SystemSoundID = 3
    private var sFastEyeSoundRecord: SystemSoundID = 4
    
    override init() {
        super.init()
        
        self.isSoundDisabled = UserDefaults.standard.bool(forKey: kUserDefaultAudioDisabledKey)
        
        //Navigation button
        var filePath = Bundle.main.path(forResource: "navigation_button", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &sFastEyeSoundNavigation)
        
        //Correct button pressed
        filePath = Bundle.main.path(forResource: "Correct", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &sFastEyeSoundCorrect)
        
        //Wrong button pressed
        filePath = Bundle.main.path(forResource: "Fail", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &sFastEyeSoundWrong)
        
        //Game ended with no new record
        filePath = Bundle.main.path(forResource: "ending_sound", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &sFastEyeSoundEnd)
        
        //Game ended with new record
        filePath = Bundle.main.path(forResource: "new_record", ofType: "wav")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: filePath!) as CFURL, &sFastEyeSoundRecord)
        
    }
    
    class func sharedInstance() -> SoundManager! {
        if _sharedInstance == nil {
            _sharedInstance = SoundManager()
        }
        return _sharedInstance
    }
    
    func toggleSoundActive() {
        self.isSoundDisabled = !self.isSoundDisabled
        objc_sync_enter(self)
        UserDefaults.standard.set(self.isSoundDisabled, forKey: kUserDefaultAudioDisabledKey)
        UserDefaults.standard.synchronize()
        objc_sync_exit(self)
    }
    
    func playNavigationSound() {
        if !self.isSoundDisabled {
            AudioServicesPlaySystemSound(sFastEyeSoundNavigation)
        }
    }
    
    func playCorrectSound() {
        if !self.isSoundDisabled {
            AudioServicesPlaySystemSound(sFastEyeSoundCorrect)
        }
    }
    
    func playWrongSound() {
        if !self.isSoundDisabled {
            AudioServicesPlaySystemSound(sFastEyeSoundWrong)
        }
    }
    
    func playEndSound() {
        if !self.isSoundDisabled {
            AudioServicesPlaySystemSound(sFastEyeSoundEnd)
        }
    }
    
    func playRecordSound() {
        if !self.isSoundDisabled {
            AudioServicesPlaySystemSound(sFastEyeSoundRecord)
        }
    }
}
