//
//  EmptyCardBackgroundView.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class EmptyCardBackgroundView: UIView {
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: containerView.center.x, y: containerView.frame.origin.y))
        path.addCurve(to: CGPoint(x:self.bounds.size.width - 25,y:90), controlPoint1: CGPoint(x:self.center.x,y:containerView.frame.origin.y - 100), controlPoint2: CGPoint(x:self.bounds.size.width - 25,y:200))
        path.lineWidth = 3.0
        let  dashes:[CGFloat] = [32.0,8.0]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        // Specify a border (stroke) color.
        UIColor.black.setStroke()
        path.stroke()
        
        let arrow = UIBezierPath()
        arrow.move(to: CGPoint(x:self.bounds.size.width - 40,y:100))
        arrow.addLine(to: CGPoint(x: self.bounds.size.width - 25, y: 85))
        arrow.addLine(to: CGPoint(x: self.bounds.size.width - 10, y: 100))
        arrow.lineWidth = 3.0
        
        UIColor.black.setStroke()
        arrow.stroke()
    }
}
