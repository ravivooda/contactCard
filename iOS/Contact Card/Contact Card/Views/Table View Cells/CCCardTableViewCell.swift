//
//  CCCardTableViewCell.swift
//  Contact Card
//
//  Created by Ravi Vooda on 1/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class CCCardTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    func updateViewWithCard(card:CCCard){
        self.nameLabel.text = "\(card.contact.givenName)"
    }
}
