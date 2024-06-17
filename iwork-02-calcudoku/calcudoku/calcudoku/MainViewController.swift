//
//  MainViewController.swift
//  calcudoku
//
//  Created by gsy on 2023/10/21.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bgv.set(mat: cal.divide)
//        initButton()
    }
    
//    func initButton(){
//        var cur = 0
//        for i in 0..<6{
//            for j in 0..<6{
//                if cal.divide[i][j] == cur{
//                    visit[i][j] = 1
//                    let sum = calculate(i: i, j: j, k: cur)
//                    cur += 1
//                    print(i, j, sum)
//                    buttons[j*6+i].subtitleLabel?.text = String(sum)
//                }
//            }
//        }
//    }
    
//    var visit: [[Int]] = Array(repeating: Array(repeating: 0, count: 6), count: 6)
//    let dir = [1, 0, -1, 0, 1]
    
//    func calculate(i: Int, j: Int, k: Int) -> Int{
//        var res = cal.matrix[i][j]
//        for d in 0..<4{
//            let di = i + dir[d], dj = j + dir[d + 1]
//            if di < 6 && di >= 0 && dj < 6 && dj >= 0{
//                if cal.divide[di][dj] == k && visit[di][dj] == 0{
//                    visit[di][dj] = 1
//                    res += calculate(i: di, j: dj, k: k)
//                }
//            }
//        }
//        
//        return res
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    var curButton: UIButton?
    var cal: Calcudoku = Calcudoku(n: 6)
    
    @IBOutlet weak var bgv: BackgroundView!
    @IBOutlet var buttons: [UIButton]!

    @IBAction func touchButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.yellow
        if let curButton{
            if (curButton != sender){
                curButton.backgroundColor = UIColor.white
            }
        }
        curButton = sender
    }
    
    var rec: [[Int]] = []
    
    @IBAction func touchNumber(_ sender: UIButton) {
        if let curButton{
            var k = 0
            while buttons[k] != curButton{
                k += 1
            }
            let s = sender.titleLabel?.text ?? ""
            curButton.setTitle(s, for: .normal)
            curButton.setTitleColor(UIColor.blue, for: .normal)
            let res = cal.getInput(i: k % 6, j: k / 6, num: Int(s)!)
            
            var rem: [Int] = []
            for (i, p) in rec.enumerated(){
                if !check(i: p[0], j: p[1]){
                    buttons[p[1]*6+p[0]].setTitleColor(UIColor.blue, for: .normal)
                    rem.append(i)
                }
            }
            rem.reverse()
            for i in rem{
                rec.remove(at: i)
            }
            
            
            for p in res{
                rec.append(p)
                buttons[p[1]*6+p[0]].setTitleColor(UIColor.red, for: .normal)
            }
            
            if cal.win(){
                let alert = UIAlertController(title: "win", message: "Congratulations, you win!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func check(i: Int, j: Int) -> Bool{
        for k in 0..<6{
            if i != k && cal.input[k][j] == cal.input[i][j]{
                return true
            }
            if j != k && cal.input[i][k] == cal.input[i][j]{
                return true
            }
        }
        return false
    }
    
    
    @IBAction func replace(_ sender: UIButton) {
        for i in 0..<buttons.count{
            buttons[i].setTitle("", for: .normal)
        }
        
        cal.clear()
        rec.removeAll()
    }
    
}
