//
//  QRShareViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 5/13/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import CloudKit
import QRCode

class QRThumbnailView: ThumbnailView {
	override func awakeFromNib() {
		availableWidth = 60
		super.awakeFromNib()
		
		self.borderColor = UIColor.lightGray
		self.borderWidth = 0.5
	}
}

class QRShareViewController: UIViewController {
    var code:QRCode!
    var command:Command?
    var activity:UIActivity?
	var contact:CNContact!

    @IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var thumbnailView: QRThumbnailView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var secondLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.nameLabel.text = self.contact.fullName
		self.secondLabel.text = self.contact.employmentDescription
		self.thumbnailView.contact = self.contact
	}
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		self.code.color = CIColor(red: 0.1, green: 0.2, blue: 0.3)
        self.code.size = self.imageView.frame.size
        self.imageView.image = self.code.image
    }

    @IBAction func dismissQRCode(_ sender: Any) {
        command?.finished()
        activity?.activityDidFinish(true)
        self.dismiss(animated: true, completion: nil)
    }
}
