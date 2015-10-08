//
//  StartViewController.swift
//  FastEye
//
//  Created by Nicholas Allio on 08/10/15.
//  Copyright © 2015 Nicholas Allio. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "up" {
            let vc:GameViewController = segue.destinationViewController as! GameViewController
            vc.display = 1
            vc.gameMode = GameViewController.GameMode.UpCount
        } else if segue.identifier == "down" {
            let vc:GameViewController = segue.destinationViewController as! GameViewController
            vc.display = 25
            vc.gameMode = GameViewController.GameMode.DownCount
        } else if segue.identifier == "random" {
            let vc:GameViewController = segue.destinationViewController as! GameViewController
            var num = rand() % 26
            while num == 0 {
                num = rand() % 26
            }
            vc.display = Int(num)
            vc.gameMode = GameViewController.GameMode.Random
        }
    }


}

