//
//  CCMyCardsViewController.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

class CCMyCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var tableView: UITableView!

	@IBAction func addNewCard(_ sender: Any) {
		
	}
	
	//MARK: - UITableViewDataSource -
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cardTableViewCellIdentifier", for: indexPath)
		return cell
	}
	
	//MARK: - UITableViewDelegate -
}
