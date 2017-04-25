//
//  BordererButton.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class BordererButton: UIButton {

    func setupLayout() {
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        
        //contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

}
