//
//  BackgroundView.swift
//  calcudoku
//
//  Created by gsy on 2023/10/21.
//

import UIKit

class BackgroundView: UIView {

    
    var div: [[Int]] = []
    func set(mat: [[Int]]){
        div = mat
    }
    
    let dir = [0, -1, 0]
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let l1 = UIBezierPath()
        l1.lineWidth = 2
        let l2 = UIBezierPath()
        l2.lineWidth = 1

        let dx = rect.width / 6, dy = rect.height / 6
        for i in 0..<6{
            for j in 0..<6{
                for k in 0..<2{
                    if isDiv(i: j, j: i, k: k){
                        l1.move(to: CGPoint(x: CGFloat(i) * dx, y: CGFloat(j) * dy))
                        l1.addLine(to: CGPoint(x: CGFloat(i + k) * dx, y: CGFloat(j + 1 - k) * dy))
                        l1.stroke()
                    }else{
                        l2.move(to: CGPoint(x: CGFloat(i) * dx, y: CGFloat(j) * dy))
                        l2.addLine(to: CGPoint(x: CGFloat(i + k) * dx, y: CGFloat(j + 1 - k) * dy))
                        l2.stroke()
                    }
                }
            }
        }
        
    }
    
    func isDiv(i: Int, j: Int, k: Int) -> Bool {
        let di = i + dir[k], dj = j + dir[k + 1]
        if di < 0 || dj < 0 || di >= div.count || dj >= div.count{
            return false
        }
        return div[i][j] != div[di][dj]
    }
    

}
