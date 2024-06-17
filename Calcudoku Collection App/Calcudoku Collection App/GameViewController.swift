//
//  GameViewController.swift
//  Calcudoku Collection App
//
//  Created by gsy on 2024/1/10.
//

import UIKit

class GameViewController: UIViewController {
    
    var calcudoku: Calcudoku? = nil
    var buttons: [[UIButton?]] = []
    var numberButtons: [UIButton?] = []
    var curButton: UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.cyan
        let width = self.view.frame.width
        let height = self.view.frame.height
        let bgv = BackgroundView(frame: CGRect(x: 0, y: height / 2 - width / 2, width: width, height: width))
        bgv.backgroundColor = UIColor.white
        bgv.set(problem: calcudoku!.problem)
        self.view.addSubview(bgv)
        
        initButtons()
        initNumberButtons()
    }
    
    func initButtons(){
        buttons = Array(repeating: Array(repeating: nil, count: calcudoku!.cnt), count: calcudoku!.cnt)
        
        let width = self.view.frame.width, height = self.view.frame.height
        let start_x = CGFloat(0), start_y = height / 2 - width / 2
        let step = width / CGFloat(calcudoku!.cnt)
        
        for i in 0..<calcudoku!.cnt{
            for j in 0..<calcudoku!.cnt{
                let button = UIButton(frame: CGRect(x: start_x + step * CGFloat(i) + CGFloat(1), y: start_y + step * CGFloat(j) + CGFloat(1), width: step - CGFloat(2), height: step - CGFloat(2)))
                
                button.backgroundColor = UIColor.gray
                
                button.titleLabel?.numberOfLines = 0
                
                button.setAttributedTitle(genAttributedString(mainTitle: " ", subTitle: calcudoku?.problem[j][i][0] ?? " "), for: .normal)
                
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                self.view.addSubview(button)
                
                buttons[i][j] = button
            }
        }
    }
    
    func initNumberButtons(){
        numberButtons = Array(repeating: nil, count: calcudoku!.cnt)
        
        let width = self.view.frame.width, height = self.view.frame.height
        let dist = CGFloat(100), step = width / CGFloat(calcudoku!.cnt)
        
        for i in 0..<calcudoku!.cnt{
            let button = UIButton(frame: CGRect(x: CGFloat(i) * step, y: height - step - dist, width: step, height: step))
            
            button.backgroundColor = UIColor.brown
            
            button.setTitleColor(UIColor.blue, for: .normal)
            button.setTitle(String(i+1), for: .normal)
            
            button.layer.cornerRadius = 15
            
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
            
            self.view.addSubview(button)
            
            numberButtons[i] = button
        }
    }
    
    var rec: [[Int]] = []
    
    @objc func numberButtonTapped(_ sender: UIButton){
        if curButton != nil{
            let num = sender.title(for: .normal)!
            let title = curButton!.attributedTitle(for: .normal)
            curButton!.setAttributedTitle(genAttributedString(mainTitle: num, subTitle: title!.string.components(separatedBy: "\n").first!), for: .normal)
            
            for (rowIdx, row) in buttons.enumerated(){
                for (colIdx, val) in row.enumerated(){
                    if val == curButton{
                        if let ret = calcudoku?.getInput(i: colIdx, j: rowIdx, num: Int(num)!){
                            
                            var rem: [Int] = []
                            for (i, row) in rec.enumerated(){
                                if !check(i: row[1], j: row[0]){
                                    let button = buttons[row[1]][row[0]]
                                    let titles = button!.attributedTitle(for: .normal)!.string.components(separatedBy: "\n")
                                    buttons[row[1]][row[0]]?.setAttributedTitle(genAttributedString(mainTitle: titles[1], subTitle: titles[0]), for: .normal)
                                    rem.append(i)
                                }
                            }
                            rem.reverse()
                            for i in rem{
                                rec.remove(at: i)
                            }
                            
                            for row in ret{
                                let button = buttons[row[1]][row[0]]
                                let titles = button!.attributedTitle(for: .normal)!.string.components(separatedBy: "\n")
                                buttons[row[1]][row[0]]?.setAttributedTitle(genAttributedString(mainTitle: titles[1], subTitle: titles[0], color: UIColor.red), for: .normal)
                                rec.append(row)
                            }
                        }
                    }
                }
            }
            
            if calcudoku!.win(){
                let alert = UIAlertController(title: "Congradulations!", message: "you have completed it!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func check(i: Int, j: Int) -> Bool{
        for k in 0..<calcudoku!.cnt{
            if i != k && calcudoku!.current[k][j] == calcudoku!.current[i][j]{
                return true
            }
            if j != k && calcudoku!.current[i][k] == calcudoku!.current[i][j]{
                return true
            }
        }
        return false
    }
    
    @objc func buttonTapped(_ sender: UIButton){
        if curButton != nil{
            curButton?.backgroundColor = UIColor.gray
        }
        curButton = sender
        curButton?.backgroundColor = UIColor.orange
    }
    
    func genAttributedString(mainTitle: String, subTitle: String, color: UIColor = UIColor.black) -> NSAttributedString{
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: subTitle, attributes: [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: color.cgColor]))
        attributedString.append(NSAttributedString(string: "\n\(mainTitle)", attributes: [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: color.cgColor]))
        attributedString.append(NSAttributedString(string: "\n ", attributes: [.font: UIFont.systemFont(ofSize: 10), .foregroundColor: color.cgColor]))
        return attributedString
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
