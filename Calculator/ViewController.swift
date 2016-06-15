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
        history.text = "";
        userIsInTheMiddleOfTyping = false
        
        brain.clear()
    }
    
    
    @IBAction func backspace() {
        if (userIsInTheMiddleOfTyping) {
            if ((display.text!.characters.count) > 1) {
                display.text = String(display.text!.characters.dropLast(1))
            } else if ((display.text?.characters.count) == 1) {
                display.text = "0"
                userIsInTheMiddleOfTyping = false
            }
        }
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
        }
    }
    
    
    private func updateBrainDescription(symbol: String) {
        // Ensure only operands are in description
        if (!history.text!.hasSuffix("=")) {
            brain.description += display.text!
        }
        
        if (symbol != "=") {
            brain.description += symbol
        }
    }
    
    
    @IBAction private func performOperation(sender: UIButton) {
        // Set operand if something has been entered, otherwise use current result
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            updateBrainDescription(mathematicalSymbol)
        }
        
        displayValue = brain.result
        history.text = (brain.isPartialResult) ?
            brain.description + "..." :
            brain.description + "="
        
        print("Internal Program \(brain.program)")
    }
}

