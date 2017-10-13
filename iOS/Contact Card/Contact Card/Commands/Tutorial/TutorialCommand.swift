//
//  TutorialCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 10/12/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import OnboardingKit

class TutorialCommand: Command {
    private let onboardingView = OnboardingView()
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        
        let view = self.onboardingView
        view.dataSource = self
        view.delegate = self
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.addSubviewWithOccupyingConstraints(subView: view)
        self.presentingViewController.view.addSubviewWithOccupyingConstraints(subView: backgroundView)
    }
}
