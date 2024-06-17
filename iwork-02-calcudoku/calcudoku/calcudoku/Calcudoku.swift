//
//  Calcudoku.swift
//  calcudoku
//
//  Created by gsy on 2023/10/22.
//

import UIKit

class Calcudoku: NSObject {
    var matrix: [[Int]]
    var divide: [[Int]]
    var input: [[Int]]
    
    init(n: Int){
        matrix = Array(repeating: Array(repeating: 0, count: n), count: n)
        divide = Array(repeating: Array(repeating: 0, count: n), count: n)
        input = Array(repeating: Array(repeating: -1, count: n), count: n)
        
        matrix = [[5, 4, 2, 6, 1, 3],
                  [4, 6, 1, 5, 3, 2],
                  [6, 5, 3, 2, 4, 1],
                  [2, 1, 4, 3, 5, 6],
                  [1, 3, 6, 4, 2, 5],
                  [3, 2, 5, 1, 6, 4],]
        divide = [[0, 1, 1, 2, 2, 3],
                  [0, 4, 1, 5, 2, 6],
                  [7, 4, 8, 5, 5, 6],
                  [7, 8, 8, 9, 10, 11],
                  [12, 13, 14, 9, 10, 11],
                  [12, 13, 14, 15, 15, 15]]
    }
    
    func load(mat: [[Int]], div: [[Int]]){
        matrix = mat
        divide = div
    }
    
    func getInput(i: Int, j: Int, num: Int) -> [[Int]]{
        input[i][j] = num
        var res: [[Int]] = []
        for k in 0..<input.count{
            if i != k && input[k][j] == num{
                res.append([k, j])
            }
            if j != k && input[i][k] == num{
                res.append([i, k])
            }
        }
        if res.count > 0{
            res.append([i, j])
        }
        return res
    }
    
    func clear(){
        for i in 0..<6{
            for j in 0..<6{
                input[i][j] = -1
            }
        }
    }
    
    func win() -> Bool{
        for i in 0..<6{
            for j in 0..<6{
                if input[i][j] != matrix[j][i]{
                    return false
                }
            }
        }
        return true
    }
    
}
