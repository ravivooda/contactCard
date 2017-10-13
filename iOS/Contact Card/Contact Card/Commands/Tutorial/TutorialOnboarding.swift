//
//  TutorialOnboarding.swift
//  Contact Card
//
//  Created by Ravi Vooda on 10/12/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import Foundation
import OnboardingKit

extension TutorialCommand: OnboardingViewDelegate, OnboardingViewDataSource {
    func numberOfPages() -> Int {
        return 5
    }
    
    func onboardingView(_ onboardingView: OnboardingView, configurationForPage page: Int) -> OnboardingConfiguration {
        var imageName = "contact_intro"
        var pageTitle = "Welcome to Contact Card"
        var pageDescription = "Contact Card helps you organize your identity and keep everyone up to date with your information.\n\nIt also keeps your contacts up to date"
        
        switch page {
        case 1:
            pageTitle = "Identity(s)"
            pageDescription = "One has many jobs in a day. Family, Colleague, Football Supporter, Weekend Surfer etc. Now you can share the exact relevant information with each group!"
        case 2:
            imageName = "protected"
            pageTitle = "Security and Privacy"
            pageDescription = "We take privacy very seriously.\nYour data will always remain in your iCloud.\n We don't make copies or share it.\n\nOur underlying technology CloudKit provides industry standard security and encryption."
        default: break
        }
        
        return OnboardingConfiguration(
            image: UIImage(named: imageName)!,
            itemImage: UIImage(named: "protected_icon")!,
            pageTitle: pageTitle,
            pageDescription: pageDescription
        )
    }
    
    func onboardingView(_ onboardingView: OnboardingView, configurePageView pageView: PageView, atPage page: Int) {
        pageView.descriptionLabel.textColor = .lightGray
        pageView.descriptionLabel.font = UIFont.systemFont(ofSize: 15.0)
        pageView.titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBold)
        pageView.titleLabel.adjustsFontSizeToFitWidth = true
    }
}
