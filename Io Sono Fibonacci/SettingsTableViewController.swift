//
//  SettingsTableViewController.swift
//  Io Sono Fibonacci
//
//  Created by Bastian Wirth on 05.01.16.
//  Copyright © 2016 Bastian Wirth. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
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
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.tag == 5 {
            // If the identifier is 5, it is the contact cell:
            // Bring up the mail view controller:
            if MFMailComposeViewController.canSendMail() {  // Checking if mail is available
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                // Configure the view controller:
                composeVC.setToRecipients(["bastian.wirth@appsforx.de"])
                composeVC.setSubject("Feedback to Io Sono Fibonacci")
                composeVC.setMessageBody("My Feedback", isHTML: false)
                
                // Presenting the view controller:
                self.presentViewController(composeVC, animated: true, completion: nil)
                
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if result == MFMailComposeResultFailed {
            print("Error sending mail.")
        }
        
        // Dismiss the mail compose view controller
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
