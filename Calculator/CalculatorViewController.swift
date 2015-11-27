//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Pavel Ostanin on 19/10/2015.
//  Copyright © 2015 Pavel Ostanin. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyDisplay: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var operandStack : Array <Double> = Array <Double>()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if ((display.text!.rangeOfString(".")) != nil && digit == ".") {
            return
        }
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
            display.adjustsFontSizeToFitWidth = true
            display.minimumScaleFactor = 0.3
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber {
            addToHistory(display.text!)
        }
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
    }
    
    @IBAction func cancel() {
        historyDisplay.text = ""
        operandStack.removeAll()
        userIsInTheMiddleOfTypingANumber = false
        display.text = "0";
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            addToHistory(operation)
        
            switch operation {
                case "X": performOperation {$1 * $0}
                case "/": performOperation {$1 / $0}
                case "+": performOperation {$1 + $0}
                case "-": performOperation {$1 - $0}
                case "sqrt": performOperation (sqrt)
                case "sin": performOperation (sin)
                case "cos": performOperation (cos)
                case "Pi": performOperation  {M_PI}
            default: break
        }
        }
    }
    func addToHistory (text : String) {
//        historyDisplay.text = historyDisplay.text!.rangeOfString("=") != nil ?
        historyDisplay.text = historyDisplay.text! + " " + text
    }
    @nonobjc func performOperation (operation : (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation (operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    @nonobjc func performOperation (operation : (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation (operandStack.removeLast())
            enter()
        }
    }
    
    @nonobjc func performOperation (operation : () -> Double) {
            displayValue = operation ()
            enter()
    }
    
    var displayValue : Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}
