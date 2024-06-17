//
//  Caculator.swift
//  caculator
//
//  Created by gsy on 2023/10/4.
//

import UIKit

class Caculator: NSObject {
    enum Operation{
        case UnaryOp((Double)->Double)
        case BinaryOp((Double, Double)->Double)
        case EqualOp
        case Clear
    }
    
    var operations = [
        "+": Operation.BinaryOp{
            (op1, op2) in
            return op1 + op2
        },
        
        "-": Operation.BinaryOp{
            (op1, op2) in
            return op1 - op2
        },
        
        "×": Operation.BinaryOp{
            (op1, op2) in
            return op1 * op2
        },
        
        "÷": Operation.BinaryOp{
            (op1, op2) in
            return op1 / op2
        },
        
        "=": Operation.EqualOp,
        
        "%": Operation.UnaryOp{ 
            op in
            return op / 100.0
        },
        
        "+/-": Operation.UnaryOp{
            op in
            return -op
        },
        
        "AC":  Operation.Clear,
    ]
    
    struct Intermidiate{
        var firstOp: Double
        var waitingOperation: (Double, Double)->Double
    }
    
    var pendingOp: Intermidiate? = nil
    
    func performOperation(operation: String, operand: Double) -> Double?{
        if let op = operations[operation]{
            switch op{
            case .BinaryOp(let function):
                pendingOp = Intermidiate(firstOp: operand, waitingOperation: function)
                return nil
            case .UnaryOp(let function):
                return function(operand)
            case .EqualOp:
                return pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
            case .Clear:
                pendingOp = Intermidiate(firstOp: 0, waitingOperation: {
                    (op1, op2) in
                    return 0
                })
                return 0
            }
        }
        return nil
    }
    
}
