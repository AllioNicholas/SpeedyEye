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
        case upCount
        case downCount
        case random

        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else { return nil }
            
            self.init(rawValue: last)
        }

    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        _ = GameCenterManager.sharedInstance()
        _ = SoundManager.sharedInstance()
        
        // Override point for customization after application launch.
        var shouldPerformAdditionalDelegateHandling = true
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem]
                as? UIApplicationShortcutItem {
            
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

        switch shortCutType {
        case ShortcutItemType.upCount.rawValue:
            segueID = "up"
            handled = true
        case ShortcutItemType.downCount.rawValue:
            segueID = "down"
            handled = true
        case ShortcutItemType.random.rawValue:
            segueID = "random"
            handled = true
        default:
            break
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "root")
        window?.rootViewController?.addChild(storyboard.instantiateViewController(withIdentifier: "Start"))
        window?.rootViewController?.children.first?.performSegue(withIdentifier: segueID, sender: nil)

        return handled
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        let handledShortCutItem = handleShortCutItem(shortcutItem)

        completionHandler(handledShortCutItem)
    }
}
