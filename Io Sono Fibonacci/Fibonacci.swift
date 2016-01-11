//
//  Fibonacci.swift
//  Io Sono Fibonacci
//
//  Created by Bastian Wirth on 03.01.16.
//  Copyright © 2016 Bastian Wirth. All rights reserved.
//

import Foundation

class Fibonacci: NSObject {
    var includeZero = true
    
    static let maxIndex = 93   // The maximum index. Otherwise the numbers would get bigger than the maximum size of a UInt on 64bit systems.
    
    /// Returns a Fibonacci number with the given index.
    func fibonacciNumber(n: Int)->FibonacciNumber {
        // This is only split for better reading
        let first = 1/sqrt(Double(5))
        let second = pow((1+sqrt(Double(5)))/2, Double(n))
        let third = pow((1-sqrt(Double(5)))/2, Double(n))
        
        let result = round(first*second-first*third)
        
        let number = FibonacciNumber(index: n, number: UInt(result))
        
        return number
    }
    
    /// Returns a sequence of Fibonacci numbers.
    func fibonacciSequence(var untilIndex: Int)->[FibonacciNumber] {
        if untilIndex < 0 {
            untilIndex = 0
        }
        var numbers = [FibonacciNumber]()
        
        var counter: Int
        if self.includeZero == true {
            counter = 1
            numbers.append(FibonacciNumber(index: 0, number: 0))
        } else {
            counter = 0
        }
        var fib1 = UInt(1)
        var fib2 = UInt(0)
        
        for var i = counter; i < untilIndex+1; i++ {
            let fibonacciNumber = FibonacciNumber(index: i, number: fib1 + fib2)
            numbers.append(fibonacciNumber)
            fib1 = fib2
            fib2 = fibonacciNumber.number
        }
        
        return numbers
    }
    
    /// Returns a random Fibonacci number.
    func randomFibonacciNumber(maxIndex: Int)->FibonacciNumber {
        let randomIndex = arc4random_uniform(UInt32(maxIndex+1))    // Getting an index between 0 and 93.
        let number = fibonacciNumber(Int(randomIndex))
        return number
    }
    
    /// Returns whether a number is a Fibonacci number or not.
    func isFibonacciNumber(number: UInt)->Bool {
        let numbers = fibonacciSequence(Fibonacci.maxIndex) // Getting the sequence.
        for var i = 0; i < Fibonacci.maxIndex; ++i {
            let aNumber = numbers[i]
            if number == aNumber.number {
                return true
            }
        }
        return false
    }
    
}
