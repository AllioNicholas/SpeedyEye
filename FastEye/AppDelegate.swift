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
    var shortcutItemToProcess: UIApplicationShortcutItem?
    
    private enum ShortcutItemType {
        static let upCount = "UpCount"
        static let downCount = "DownCount"
        static let random = "Random"
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // If a shortcut was launched, display its information and take the appropriate action
        if let shortcutItem =
            launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            shortcutItemToProcess = shortcutItem
        }

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let shortcut = shortcutItemToProcess {
            
            handleShortCutItem(shortcut)
            
            shortcutItemToProcess = nil
        }
    }

    func application(_ application: UIApplication,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        shortcutItemToProcess = shortcutItem
    }
    
    // MARK: Application Shortcut
    func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) {
        guard let shortCutType = shortcutItem.type as String? else { return }

        var segueID = ""

        switch shortCutType {
        case ShortcutItemType.upCount:
            segueID = "upcount"
        case ShortcutItemType.downCount:
            segueID = "downcount"
        case ShortcutItemType.random:
            segueID = "random"
        default:
            break
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window!.rootViewController = storyboard.instantiateViewController(withIdentifier: "root")
        window?.rootViewController?.addChild(storyboard.instantiateViewController(withIdentifier: "Start"))
        window?.rootViewController?.children.first?.performSegue(withIdentifier: segueID, sender: nil)
    }
}
