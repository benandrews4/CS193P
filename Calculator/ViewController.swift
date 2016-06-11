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
    
    private var userIsInTheMiddleOfTyping = false
    
    
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
    
    
    @IBAction private func touchPoint(sender: UIButton) {
        if (!userIsInTheMiddleOfTyping) {
            display.text = "0."
        } else if (display.text!.rangeOfString(".") == nil) {
            display.text = display.text! + "."
        }
        userIsInTheMiddleOfTyping = true
    }
    
    
    @IBAction func touchClear(sender: UIButton) {
        displayValue = 0;
        history.text = "";
        userIsInTheMiddleOfTyping = false
        brain.pending = nil;
        brain.description = "";
    }
    
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            let digit = String(newValue)
            display.text = digit.hasSuffix(".0") ? String(digit.characters.dropLast(2)) : digit
        }
    }
    
    
    private var brain = CalculatorBrain()
    
    
    private func updateBrainDescription(symbol: String) {
        if (!history.text!.hasSuffix("=")) {
            brain.description += display.text!
        }
        
        if (symbol != "=") {
            brain.description += symbol
        }
    }
    
    
    @IBAction private func performOperation(sender: UIButton) {
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
    }
}

