//
//  Calcudoku.swift
//  Calcudoku Collection App
//
//  Created by gsy on 2024/1/10.
//

import UIKit

class Calcudoku: NSObject {
    var answer: [[Int]]
    var problem: [[[String]]]
    var current: [[Int]]
    let cnt: Int
    
    init(n: Int){
        cnt = n
        answer = Array(repeating: Array(repeating: 0, count: n), count: n)
        problem = Array(repeating: Array(repeating: Array(repeating: " ", count: 3), count: n), count: n)
        current = Array(repeating: Array(repeating: -1, count: n), count: n)
    }
    
    func load(ans: [[Int]], pro: [[[String]]]){
        answer = ans
        problem = pro
    }
    
    func getInput(i: Int, j: Int, num: Int) -> [[Int]]{
        current[i][j] = num
        var res: [[Int]] = []
        for k in 0..<cnt{
            if i != k && current[k][j] == num{
                res.append([k, j])
            }
            if j != k && current[i][k] == num{
                res.append([i, k])
            }
        }
        if res.count > 0{
            res.append([i, j])
        }
        return res
    }
    
    func clear(){
        for i in 0..<cnt{
            for j in 0..<cnt{
                current[i][j] = -1
            }
        }
    }
    
    func win() -> Bool{
        for i in 0..<cnt{
            for j in 0..<cnt{
                if current[i][j] != answer[i][j]{
                    return false
                }
            }
        }
        return true
    }
    
}
