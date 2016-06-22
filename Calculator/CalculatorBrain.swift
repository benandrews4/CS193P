//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ben Andrews on 08/06/2016.
//  Copyright © 2016 Ben Andrews. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    var variableValues: Dictionary<String, Double> = [:]
    
    
    func setOperand(variableName: String) {
        if let operand = variableValues[variableName] {
            accumulator = operand
            
            // Calculator variables
            var variables = [String: Double]()
            variables[variableName] = operand
            internalProgram.append(variables)
        } else {
            accumulator = 0.0
        }
    }
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "sinh" : Operation.UnaryOperation(sinh),
        "cosh" : Operation.UnaryOperation(cosh),
        "tanh" : Operation.UnaryOperation(tanh),
        "x²" : Operation.UnaryOperation({ pow($0, 2) }),
        "±" : Operation.UnaryOperation({ -$0 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "xʸ" : Operation.BinaryOperation({ pow($0, $1) }),
        "=" : Operation.Equals
    ]
    
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePrivateBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePrivateBinaryOperation()
            }
        }
    }
    
    
    private func executePrivateBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    private var pending: PendingBinaryOperationInfo?
    
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    
    private let CALC_VARIABLES = ["M"]
    
    typealias PropertyList = AnyObject
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    // Variable
                    if op is [String: Double] {
                        for calcVar in CALC_VARIABLES {
                            var variables = op as! [String : Double]
                            variableValues[calcVar] = variables[calcVar]
                            setOperand(calcVar)
                            
                            self.description += calcVar
                        }
                        
                    // Operand
                    } else if let operand = op as? Double {
                        setOperand(operand)
                        self.description += String(operand)
                        
                    // Operation
                    } else if let operation = op as? String {
                        performOperation(operation)
                        self.description += operation
                    }
                }
            }
        }
    }
    
    
    var description: String = ""
    
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
        variableValues = [:]
        description = ""
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
}