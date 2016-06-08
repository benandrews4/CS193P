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
        userIsInTheMiddleOfTyping = false
        brain.pending = nil;
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
    
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
}

