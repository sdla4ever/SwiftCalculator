//
//  ViewController.swift
//  SwiftCalculator
//
//  Created by Martin Calvert on 8/2/15.
//  Copyright (c) 2015 Martin Calvert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var display: UILabel!

    @IBOutlet weak var history: UILabel!
    // Variables
    var userIsTypingNumber = false
    var opperandStack = Array<Double>()
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
        }
    }
    var lastOperation = UIButton?()
    
    // Methods
    @IBAction func appendDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        switch digit{
            case "pi": digit = "\(M_PI)"
            case ".":
                if display.text!.rangeOfString(".") != nil {
                    digit = "" }
            default: break
        }
        if userIsTypingNumber{
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsTypingNumber = true
        }
        history.text = history.text! + " \(digit)"
    }
    
    @IBAction func enter() {
        userIsTypingNumber = false
        opperandStack.append(displayValue)
        if lastOperation != nil{
            operate(lastOperation!)
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        lastOperation = sender
        if userIsTypingNumber{
            userIsTypingNumber = false
            opperandStack.append(displayValue)
        }
        switch operation{
            case "✖️": performOperation { $0 * $1 }
            case "➗": performOperation { $0 / $1 }
            case "➖": performOperation { $0 - $1 }
            case "➕": performOperation { $0 + $1 }
            case "√": performOperation { sqrt($0) }
            case "sin": performOperation { sin($0) }
            case "cos": performOperation { cos($0) }
            default: break
        }
        if lastOperation != nil{
            history.text = history.text! + " \(lastOperation!.currentTitle!)"
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if opperandStack.count >= 2{
            displayValue = operation(opperandStack.removeLast(), opperandStack.removeLast())
            opperandStack.append(displayValue)
            lastOperation = nil
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if opperandStack.count >= 1{
            displayValue = operation(opperandStack.removeLast())
            opperandStack.append(displayValue)
            history.text = history.text! + " \(lastOperation!.currentTitle!)"
            lastOperation = nil
        }
    }
    
    @IBAction func reset(sender: UIButton) {
        displayValue = 0
        opperandStack = Array<Double>()
        userIsTypingNumber = false
        history.text = ""
    }

}

