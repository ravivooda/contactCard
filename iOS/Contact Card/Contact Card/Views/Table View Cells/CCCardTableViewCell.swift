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
    @IBOutlet weak var thumnailImageView: UIImageView!
    
    var card:CCCard! {
        didSet {
            self.nameLabel.text = "\(card.cardName)"
            self.thumnailImageView.image = card.thumbnailImage
        }
    }
}
