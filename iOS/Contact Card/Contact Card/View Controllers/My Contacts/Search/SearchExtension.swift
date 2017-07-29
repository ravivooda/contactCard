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
        
        let sectionForResults:ContactsDisplayTableViewController.ContactSection = ContactSection(name: "", contacts: [])
        for section in self.contactSections {
            for contact in section.contacts {
                if contact.displayName().contains(searchText) {
                    sectionForResults.contacts.append(contact)
                }
            }
        }
        self.searchResultsController.contactSections = [sectionForResults]
        self.searchResultsController.tableView.reloadData()
    }
}
