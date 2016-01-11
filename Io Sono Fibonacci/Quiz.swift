//
//  Quiz.swift
//  Io Sono Fibonacci
//
//  Created by Bastian Wirth on 04.01.16.
//  Copyright © 2016 Bastian Wirth. All rights reserved.
//

import Foundation

/// This class holds properties and functions for the quiz.
public class Quiz: NSObject {
    public var delegate: QuizDelegate?
    public private(set) var timeInSeconds: Int?
    public private(set) var startTime: NSDate?
    public private(set) var stopTime: NSDate?
    public private(set) var isPlaying: Bool! = false
    
    public private(set) var right: Int! = 0
    public private(set) var wrong: Int! = 0


    public private(set) var currentNumber: UInt! = 0
    private var currentNumberIsFibonacci: Bool! = false

    
    private let timer = NSTimer()
    
    override init() {
        super.init()
        self.new()
    }
    
    // Resetting all properties and starting a new game:
    public func new() {
        startTime = nil
        stopTime = nil
        isPlaying = false
        right = 0
        wrong = 0
        currentNumber = 0
        currentNumberIsFibonacci = false
    }
    
    /// Starting a new quiz session.
    public func start() {
        self.new()
        self.startTime = NSDate()
        self.isPlaying = true
        self.generateNumber()
        self.delegate?.didStartQuiz(self)
    }
    
    /// Stopping the quiz session.
    public func stop() {
        self.stopTime = NSDate()
        self.isPlaying = false
        
        let interval = stopTime!.timeIntervalSinceDate(startTime!)
        timeInSeconds = Int(interval)
        
        self.delegate?.didStopQuiz(self)
    }
    
    public func playerAnswered(answer: Bool) {
        if answer == currentNumberIsFibonacci {
            self.answeredRight()
        } else {
            self.answeredWrong()
        }
        
        self.generateNumber() // Generate a new number
    }
    
    private func answeredRight() {
        right = right + 1
        self.delegate?.playerAnsweredRight(self)
    }
    
    private func answeredWrong() {
        wrong = wrong + 1
        self.delegate?.playerAnsweredWrong(self)
        
    }
    
    /// Generates a random number and tells (if possible) the delegate.
    private func generateNumber() {
        // Generate a (almost) random number:
        let fib = Fibonacci()
        let randomFibonacci = fib.randomFibonacciNumber(Fibonacci.maxIndex)
        
        let aRandomNumber = randomNumber()
        
        if takeFibonacciNumber() == true {
            self.currentNumberIsFibonacci = true
            self.currentNumber = randomFibonacci.number
        } else {
            if fib.isFibonacciNumber(aRandomNumber) == true {   // Check if the generated number is a Fibonacci number by accident.
                self.currentNumberIsFibonacci = true
            } else {
                self.currentNumberIsFibonacci = false
            }
            self.currentNumber = aRandomNumber
        }
        
        
        self.delegate?.quiz(self, generatedNewNumber: self.currentNumber)   // Tell the deleagte
        
    }
    
}

/// Generates a random UInt32.
private func randomNumber()->UInt {
    let rnd = arc4random_uniform(UInt32.max)
    return UInt(rnd)
}

/// Returns whether the fibonnaci number should be taken or not.
private func takeFibonacciNumber()->Bool {
    let rnd = arc4random_uniform(2)
    if rnd == 1 {
        return true
    } else {
        return false
    }
}

public protocol QuizDelegate {
    func didStartQuiz(quiz: Quiz);
    func didStopQuiz(quiz: Quiz);
    
    func startQuiz()
    func stopQuiz()
    
    func playerAnswersYes()
    func playerAnswersNo()
    
    func playerAnsweredRight(quiz: Quiz)
    func playerAnsweredWrong(quiz: Quiz)
    
    func quiz(quiz: Quiz, generatedNewNumber number: UInt)

}
