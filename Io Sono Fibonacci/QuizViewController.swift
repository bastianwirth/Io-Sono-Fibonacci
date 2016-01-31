//
//  QuizViewController.swift
//  Io Sono Fibonacci
//
//  Created by Bastian Wirth on 04.01.16.
//  Copyright © 2016 Bastian Wirth. All rights reserved.
//

import UIKit
import SpriteKit
import JGProgressHUD

class QuizViewController: UIViewController, QuizDelegate {
    
    @IBOutlet weak var startStopBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var highscoreBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var bubbleSuperView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var bubbleScene: BubblesScene!
    private var bubbleView: SKView!
    private var timer: NSTimer?
    private let quiz = Quiz()
    private let resultHUD = JGProgressHUD(style: .Dark)
    
    private var dateNow: NSDate! {
        get {
            return NSDate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        quiz.delegate = self
        self.resetUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func highscoreButtonPushed(sender: AnyObject) {
        let mostRights = FibonacciUserDefaults.mostRights
        let seconds = FibonacciUserDefaults.bestSeconds
        let highscoreAlert = UIAlertController(title: "Highscore", message: "\(mostRights) right answers in \(seconds) seconds!", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            highscoreAlert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        highscoreAlert.addAction(okAction)
        self.presentViewController(highscoreAlert, animated: true, completion: nil)
    }
    
    @IBAction func startStopButtonPushed(sender: AnyObject) {
        if self.quiz.isPlaying == true {
            self.stopQuiz()
        } else {
            self.startQuiz()
        }
    }
    
    
    private func resetUI() {
        // Resetting the UI
        startStopBarButtonItem.title = "Start Quiz"
        
        let timeFont = UIFont(name: "DBLCDTempBlack", size: 40.0)
        timeLabel.font = timeFont
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.text = "00"
        
        bubbleView = SKView(frame: self.bubbleSuperView.bounds);
        bubbleView.backgroundColor = SKColor.whiteColor()
        self.bubbleSuperView.addSubview(bubbleView)
        bubbleScene = BubblesScene(size: bubbleView.bounds.size)
        bubbleScene.bottomOffset = 0
        bubbleView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        bubbleView.presentScene(bubbleScene)
        //bubbleScene.floatingDelegate = self
        
    }
    
    internal func didStartQuiz(quiz: Quiz) {
        startStopBarButtonItem.title = "Stop Quiz"
        self.highscoreBarButtonItem.enabled = false // Disable the highscore while playing
    }
    
    internal func didStopQuiz(quiz: Quiz) {
        timer?.invalidate()
        self.resetUI()
        self.displayScore(quiz.right, wrongs: quiz.wrong, seconds: quiz.timeInSeconds!)
        
        // Set (if needed) a new highscore:
        if quiz.right > FibonacciUserDefaults.mostRights {
            FibonacciUserDefaults.mostRights = quiz.right
            FibonacciUserDefaults.bestSeconds = quiz.timeInSeconds!
        }
        
        
        self.highscoreBarButtonItem.enabled = true
    }
    
    internal func playerAnswersNo() {
        if self.quiz.isPlaying == true {    // Check whether the game is running
            self.quiz.playerAnswered(false)
        }
    }
    
    internal func playerAnswersYes() {
        if self.quiz.isPlaying == true {
            self.quiz.playerAnswered(true)
        }
    }
    
    internal func playerAnsweredRight(quiz: Quiz) {
        // Paint view green:
        self.displayResult(self.view, answeredRight: true)
    }
    
    internal func playerAnsweredWrong(quiz: Quiz) {
        // Paint view red:
        self.displayResult(self.view, answeredRight: false)
    }
    
    private func displayResult(inView: UIView, answeredRight: Bool) {
        resultHUD.dismiss() // Dismiss, if already displayed
        if answeredRight == true {
            resultHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
            resultHUD.textLabel.text = "Correct"
        } else {
            resultHUD.indicatorView = JGProgressHUDErrorIndicatorView()
            resultHUD.textLabel.text = "Wrong"
        }
        resultHUD.showInView(inView)
        resultHUD.dismissAfterDelay(1)
    }
    
    internal func quiz(quiz: Quiz, generatedNewNumber number: UInt) {
        self.displayOneBubble(String(number))
    }
    
    internal func startQuiz() {
        self.resetUI()
        
        self.quiz.start()
        timer?.invalidate()
        timer = NSTimer()
        timer = NSTimer(timeInterval: 1.0, target: self, selector: "updateTimerLabel", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    internal func stopQuiz() {
        self.quiz.stop()
    }
    
    func updateTimerLabel() {
        if self.quiz.startTime != nil {
            let interval = UInt(NSDate().timeIntervalSinceDate(self.quiz.startTime!))
            //        let milli = (interval % 60)
            //        let seconds = (interval / 60) % 60
            //        let minutes = interval / 3600
            
            //self.timeLabel.text = "\(milli):\(seconds):\(minutes)"
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.timeLabel.text = String(interval)
            }
        }
    }
    
    private func displayOneBubble(text: String) {
        //self.bubbleScene.removeAllChildren()
        for i in 0..<self.bubbleScene.floatingNodes.count {
            self.bubbleScene.removeFloatinNodeAtIndex(i)
        }
        let node = self.quizNode(text)
        //node.position = CGPointMake(bubbleSuperView.bounds.width / 2, bubbleSuperView.bounds.height / 2)
        bubbleScene.addChild(node)
    }
    
    private func displayScore(rights: Int, wrongs: Int, seconds: Int) {
        for i in 0..<self.bubbleScene.floatingNodes.count {
            self.bubbleScene.removeFloatinNodeAtIndex(i)
        }
        
        let rightNode = self.quizNode("\(rights) right.")
        let wrongNode = self.quizNode("\(wrongs) wrong.")
        let secondsNode = self.quizNode("\(seconds) seconds.")

        bubbleScene.addChild(rightNode)
        bubbleScene.addChild(wrongNode)
        bubbleScene.addChild(secondsNode)

    }
    
    private func hideBubble() {
        self.bubbleScene.removeAllChildren()
    }
    
    
    @IBAction func noButtonPushed(sender: AnyObject) {
        self.playerAnswersNo()
    }
    
    @IBAction func yesButtonPushed(sender: AnyObject) {
        self.playerAnswersYes()
    }
    
    
    private func quizNode(text: String) -> SIFloatingNode {
        let node = SIFloatingNode(circleOfRadius: 60)
        let labelNode = SKLabelNode(fontNamed: "")
        
        let boundingBox = CGPathGetBoundingBox(node.path);
        let radius = boundingBox.size.width / 2.0;
        node.physicsBody = SKPhysicsBody(circleOfRadius: radius + 1.5)
        node.fillColor = SKColor.redColor()
        node.strokeColor = node.fillColor
        
        
        labelNode.text = text
        let countDigits = labelNode.text!.characters.count
        if countDigits > 0 && countDigits < 4 {
            labelNode.fontSize = 30
        } else if countDigits > 4 && countDigits < 7 {
            labelNode.fontSize = 20
        } else if countDigits > 7 {
            labelNode.fontSize = 10
        }
        labelNode.position = CGPointZero
        labelNode.fontColor = SKColor.whiteColor()
        labelNode.userInteractionEnabled = false
        labelNode.verticalAlignmentMode = .Center
        labelNode.horizontalAlignmentMode = .Center
    
        node.addChild(labelNode)
        return node
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
