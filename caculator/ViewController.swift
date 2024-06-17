//
//  ViewController.swift
//  caculator
//
//  Created by gsy on 2023/10/3.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.displayLabel.text = ""
    }
    
    var digitOnDisplay: String{
        get{
            return self.displayLabel.text!
        }
        set{
            self.displayLabel.text! = newValue
        }
    }

    var inTypingMode = false
    
    let caculator = Caculator()
    
    @IBAction func numberTouched(_ sender: UIButton) {
        if inTypingMode{
            digitOnDisplay = digitOnDisplay + (sender.titleLabel?.text)!
        }else{
            digitOnDisplay = (sender.titleLabel?.text)!
            inTypingMode = true
        }
    }

    
    @IBAction func operatorTouched(_ sender: UIButton) {
        if let op = sender.titleLabel?.text{
            if let result = caculator.performOperation(operation: op, operand: Double(digitOnDisplay)!){
                digitOnDisplay = String(result)
            }
        }
        
        inTypingMode = false
    }
    
}

