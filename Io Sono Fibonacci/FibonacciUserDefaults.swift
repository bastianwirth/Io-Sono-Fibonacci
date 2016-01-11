//
//  FibonacciUserDefaults.swift
//  Io Sono Fibonacci
//
//  Created by Bastian Wirth on 09.01.16.
//  Copyright © 2016 Bastian Wirth. All rights reserved.
//

import Foundation

public class FibonacciUserDefaults: NSObject {
    // This class contains the standard user defaults wrapped into class functions.
    
    class var shouldPlaySoundWhenTappingOnBubble: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("shouldPlaySoundWhenTappingOnBubble")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "shouldPlaySoundWhenTappingOnBubble")
        }
    }
    
    class var mostRights: Int {
        get {
        return NSUserDefaults.standardUserDefaults().integerForKey("mostRights")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "mostRights")
        }
    }
    class var bestSeconds: Int {
        get {
        return NSUserDefaults.standardUserDefaults().integerForKey("bestSeconds")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "bestSeconds")
        }
    }
}
