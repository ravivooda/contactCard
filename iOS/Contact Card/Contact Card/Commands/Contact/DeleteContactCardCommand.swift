//
//  DeleteContactCardCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/23/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit

class DeleteContactCardCommand: Command {
    private let card:CCCard
    init(card:CCCard, viewController: UIViewController, returningCommand: Command?) {
        self.card = card
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
    }
}
