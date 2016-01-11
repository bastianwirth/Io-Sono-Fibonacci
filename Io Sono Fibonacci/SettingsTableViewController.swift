//
//  SettingsTableViewController.swift
//  Io Sono Fibonacci
//
//  Created by Bastian Wirth on 05.01.16.
//  Copyright © 2016 Bastian Wirth. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var playSoundSwitch: UISwitch!
    @IBOutlet weak var versionTableViewCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Loading the current settings:
        playSoundSwitch.on = FibonacciUserDefaults.shouldPlaySoundWhenTappingOnBubble
        
        
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        versionTableViewCell.textLabel?.text = version // Version
        versionTableViewCell.detailTextLabel!.text = "Version"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSoundSwitchValueChanged(sender: UISwitch) {
        FibonacciUserDefaults.shouldPlaySoundWhenTappingOnBubble = sender.on
    }
    
    @IBAction func resetHighscoreButtonPushed(sender: AnyObject) {
        // Resetting the high score:
        FibonacciUserDefaults.bestSeconds = 0
        FibonacciUserDefaults.mostRights = 0
    }
    
    

}
