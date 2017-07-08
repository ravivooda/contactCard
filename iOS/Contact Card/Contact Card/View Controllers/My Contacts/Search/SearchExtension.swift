//
//  SearchExtension.swift
//  Contact Card
//
//  Created by Ravi Vooda on 7/7/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

extension CCMyContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = self.searchController.searchBar.text else {
            print("Empty search text")
            return
        }
        
        self.searchResultsController.contacts = []
        
        for contact in self.contacts {
            if contact.displayName().contains(searchText) {
                self.searchResultsController.contacts.append(contact)
            }
        }
        
        self.searchResultsController.tableView.reloadData()
    }
}
