//
//  ViewController.swift
//  Calculator
//
//  Created by Ben Andrews on 02/06/2016.
//  Copyright © 2016 Ben Andrews. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    @IBOutlet private weak var history: UILabel!
    
    private var brain = CalculatorBrain()
    
    private var userIsInTheMiddleOfTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            let digit = String(newValue)
            
            // Remove ".0" as variable is a Double
            display.text = digit.hasSuffix(".0") ? String(digit.characters.dropLast(2)) : digit
        }
    }
    
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if (userIsInTheMiddleOfTyping) {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    
    @IBAction private func touchPoint() {
        if (!userIsInTheMiddleOfTyping) {
            display.text = "0."
        } else if (display.text!.rangeOfString(".") == nil) {
            display.text = display.text! + "."
        }
        userIsInTheMiddleOfTyping = true
    }
    
    
    @IBAction func touchClear() {
        displayValue = 0;
        history.text = " ";
        userIsInTheMiddleOfTyping = false
        
        brain.clear()
    }
    
    
    @IBAction func undo() {
        if (userIsInTheMiddleOfTyping) {
            // Backspace
            if ((display.text!.characters.count) > 1) {
                display.text = String(display.text!.characters.dropLast(1))
            } else if ((display.text?.characters.count) == 1) {
                displayValue = 0
                userIsInTheMiddleOfTyping = false
            }
        } else {
            // Undo
            var program = brain.program as? [AnyObject]
            if program?.count > 0 {
                program?.popLast()
                brain.program = program!
                
                history.text = getHistory()
                displayValue = 0
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
    private func removePointZeros(history: String) -> String {
        return history.stringByReplacingOccurrencesOfString(".0", withString: "")
    }
    
    
    @IBAction func setMemory(sender: UIButton) {
        // ->M button
        if var calcVariable = sender.currentTitle {
            calcVariable = String(calcVariable.characters.dropFirst(1))
            brain.variableValues[calcVariable] = displayValue
            userIsInTheMiddleOfTyping = false
        }
    }
    
    
    @IBAction func getMemory(sender: UIButton) {
        // M button
        if let calcVariable = sender.currentTitle {
            brain.setOperand(calcVariable)
            display.text = calcVariable
            brain.description += display.text!
        }
    }
    
    
    private func getHistory() -> String {
        var hist = removePointZeros(brain.description)
        
        if (brain.isPartialResult) {
            hist += "..."
        } else if (hist.characters.count > 1) {
            hist += "="
        } else if (hist.characters.count == 0) {
            // Prevent view disappearing
            hist = " "
        }
        
        return hist
    }
    
    
    @IBAction private func performOperation(sender: UIButton) {
        // Set operand if something has been entered, otherwise use current result
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            brain.description += display.text!
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            
            if (mathematicalSymbol != "=") {
                brain.description += mathematicalSymbol
            }
            
            history.text = getHistory()
        }
        
        displayValue = brain.result
    }
}

