//
//  AppDelegate.swift
//  FastEye
//
//  Created by Nicholas Allio on 08/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchedShortcutItem: UIApplicationShortcutItem?
    
    enum ShortcutItemType: String {
        case UpCount
        case DownCount
        case Random
        
        // MARK: - Initializers
        
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            
            self.init(rawValue: last)
        }
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = GameCenterManager.sharedInstance()
        _ = SoundManager.sharedInstance()
        
        // Override point for customization after application launch.
        var shouldPerformAdditionalDelegateHandling = true
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            launchedShortcutItem = shortcutItem
            
            // This will block "performActionForShortcutItem:completionHandler" from being called.
            shouldPerformAdditionalDelegateHandling = false
        }
        
        return shouldPerformAdditionalDelegateHandling
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let shortcut = launchedShortcutItem else { return }
        
        _ = handleShortCutItem(shortcut)
        
        launchedShortcutItem = nil
    }
    
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handled = false
                
        guard let shortCutType = shortcutItem.type as String? else { return false }
        
        var segueID = ""
        
        switch (shortCutType) {
        case ShortcutItemType.UpCount.rawValue:
            segueID = "up"
            handled = true
            break
        case ShortcutItemType.DownCount.rawValue:
            segueID = "down"
            handled = true
            break
        case ShortcutItemType.Random.rawValue:
            segueID = "random"
            handled = true
            break
        default:
            break
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        window!.rootViewController = sb.instantiateViewController(withIdentifier: "root")
        window?.rootViewController?.addChild(sb.instantiateViewController(withIdentifier: "Start"))
        window?.rootViewController?.children.first?.performSegue(withIdentifier: segueID, sender: nil)
        
        return handled
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)
        
        completionHandler(handledShortCutItem)
    }
}

