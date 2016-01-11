//
//  BubbleViewController.swift
//  Io Sono Fibonacci
//
//  Created by Bastian Wirth on 03.01.16.
//  Copyright © 2016 Bastian Wirth. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class BubbleViewController: UIViewController, SIFloatingCollectionSceneDelegate {
    private var bubbleView: SKView!
    private var bubblesScene: BubblesScene!
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    private let readerNumberFormatter = NSNumberFormatter()
    private let synthesizer = AVSpeechSynthesizer() // The synthesizer object takes care of reading text aloud.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initBubbleView()
    }
    
    /// Inits the bubble view and it's bubbles.
    private func initBubbleView() {
        bubbleView = SKView(frame: self.view.bounds);
        bubbleView.backgroundColor = SKColor.whiteColor()
        self.view.addSubview(bubbleView)
        bubblesScene = BubblesScene(size: bubbleView.bounds.size)
        bubbleView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        bubbleView.presentScene(bubblesScene)
        bubblesScene.floatingDelegate = self
        
        
        readerNumberFormatter.numberStyle = .SpellOutStyle
        
        // Adjusting the font size based on the length of the text.
        for var i = 0; i < Fibonacci.maxIndex; ++i {
            let node = BubbleNode.instantiate() // Using the node class from the SIFloatingCollection example. I know this implementation is kinda shitti but for now it works good enough.
            node.labelNode.text = String(appDelegate.fibonacciNumbers[i].number)
            let countDigits = node.labelNode.text!.characters.count
            if countDigits > 0 && countDigits < 4 {
                node.labelNode.fontSize = 30
            } else if countDigits > 4 && countDigits < 8 {
                node.labelNode.fontSize = 15
            } else if countDigits > 12 {
                node.labelNode.fontSize = 5.5
            }
            bubblesScene.addChild(node) // Adding the bubble to the collection.
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        bubblesScene.scene!.view!.paused = false
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.synthesizer.speaking == true {
            self.synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate) // (If active) cancel the speech.
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        bubblesScene.scene!.view!.paused = true // Pausing the animated view to save energy.
        self.resignFirstResponder()
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        super.motionEnded(motion, withEvent: event)
        NSLog("Motion ended.")
        // This is called, if the user shakes the device. It generates a random Fibonacci number.
        let fibonacci = Fibonacci()
        let randomFibonacciNumber = fibonacci.randomFibonacciNumber(Fibonacci.maxIndex)
        let alertController = UIAlertController(title: "A random Fibonacci number", message: "\(randomFibonacciNumber.number) is Fibonacci number \(randomFibonacciNumber.index)", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default) { (aAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(dismissAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func floatingScene(scene: SIFloatingCollectionScene, didSelectFloatingNodeAtIndex index: Int) {
        if FibonacciUserDefaults.shouldPlaySoundWhenTappingOnBubble == true {   // Should the number be spelled out.
            let numberObject = NSNumber(unsignedInteger: appDelegate.fibonacciNumbers[index].number)    // Generating a NSNumber object from the Fibonacci number.
            
            let stringToRead = self.readerNumberFormatter.stringFromNumber(numberObject)
            let utterance = AVSpeechUtterance(string: stringToRead!)
            utterance.voice = AVSpeechSynthesisVoice()
            self.synthesizer.speakUtterance(utterance)  // Read aloud!
        }
    }
    
    func floatingScene(scene: SIFloatingCollectionScene, didDeselectFloatingNodeAtIndex index: Int) {
        if self.synthesizer.speaking == true {
            self.synthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate) // (If active) cancel the speech.
        }
    }

}
