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
    @IBOutlet weak var leftContainerView: ThumbnailView!
	@IBOutlet weak var qrShareButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftContainerView.customBorderColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.leftContainerView.awakeFromNib()
    }
    
    var card:CCCard! {
        didSet {
            self.nameLabel.text = "\(card.cardName)"
            self.leftContainerView.contact = self.card.contact
        }
    }
	
	
	@IBAction func shareQR(_ sender: UIButton) {
		if let controller = self.viewController() as? CCMyCardsViewController {
			controller.share(card: self.card, qrOnly: true)
		}
	}
}
