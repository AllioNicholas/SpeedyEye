//
//  SoundManager.swift
//  FastEye
//
//  Created by Nicholas Allio on 25/09/2017.
//  Copyright © 2017 Nicholas Allio. All rights reserved.
//

import UIKit
import AudioToolbox

let kUserDefaultAudioActiveKey = "kUserDefaultAudioActiveKey"

class SoundManager: NSObject {

    static private var _sharedInstance: SoundManager!
    
    private var _isSoundActive: Bool = true
    
    private var sFastEyeSoundNavigation: SystemSoundID = 0
    private var sFastEyeSoundCorrect: SystemSoundID = 1
    private var sFastEyeSoundWrong: SystemSoundID = 2
    private var sFastEyeSoundEnd: SystemSoundID = 3
    private var sFastEyeSoundRecord: SystemSoundID = 4
    
    override init() {
        super.init()
        
        _isSoundActive = UserDefaults.standard.bool(forKey: kUserDefaultAudioActiveKey)
        
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
        _isSoundActive = !_isSoundActive
        objc_sync_enter(self)
        UserDefaults.standard.set(_isSoundActive, forKey: kUserDefaultAudioActiveKey)
        UserDefaults.standard.synchronize()
        objc_sync_exit(self)
    }
    
    func playNavigationSound() {
        if _isSoundActive {
            AudioServicesPlaySystemSound(sFastEyeSoundNavigation)
        }
    }
    
    func playCorrectSound() {
        if _isSoundActive {
            AudioServicesPlaySystemSound(sFastEyeSoundCorrect)
        }
    }
    
    func playWrongSound() {
        if _isSoundActive {
            AudioServicesPlaySystemSound(sFastEyeSoundWrong)
        }
    }
    
    func playEndSound() {
        if _isSoundActive {
            AudioServicesPlaySystemSound(sFastEyeSoundEnd)
        }
    }
    
    func playRecordSound() {
        if _isSoundActive {
            AudioServicesPlaySystemSound(sFastEyeSoundRecord)
        }
    }
}
