//
//  BackgroundView.swift
//  Calcudoku Collection App
//
//  Created by gsy on 2024/1/10.
//

import UIKit

class BackgroundView: UIView {
    
    var problem: [[[String]]] = []
    var cnt: Int = 4
    let dir = [1, 0, 1]
    
    func set(problem: [[[String]]]){
        self.problem = problem
        cnt = problem.count
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let l1 = UIBezierPath()
        l1.lineWidth = 2
        let l2 = UIBezierPath()
        l2.lineWidth = 1
        
        let rectaglePath = UIBezierPath(rect: rect)
        rectaglePath.lineWidth = 2
        rectaglePath.stroke()
        
        let dx = rect.width / CGFloat(cnt), dy = rect.height / CGFloat(cnt)
        for i in 0..<cnt{
            for j in 0..<cnt{
                for k in 1..<3{
                    if problem[i][j][k] == "1"{
                        l1.move(to: CGPoint(x: CGFloat(j+dir[k-1]) * dx, y: CGFloat(i+dir[k]) * dy))
                        l1.addLine(to: CGPoint(x: CGFloat(j + 1) * dx, y: CGFloat(i + 1) * dy))
                        l1.stroke()
                    }else{
                        l2.move(to: CGPoint(x: CGFloat(j+dir[k-1]) * dx, y: CGFloat(i+dir[k]) * dy))
                        l2.addLine(to: CGPoint(x: CGFloat(j + 1) * dx, y: CGFloat(i + 1) * dy))
                        l2.stroke()
                    }
                }
            }
        }
    }
    
}
