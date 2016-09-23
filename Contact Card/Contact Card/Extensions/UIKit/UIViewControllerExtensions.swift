//
//  UIViewControllerExtensions.swift
//  Contact Card
//
//  Created by Ravi Vooda on 9/10/16.
//  Copyright © 2016 Utils. All rights reserved.
//

import UIKit

extension UIViewController {
    func showLoading() -> Void {
        let loadingController = LoadingViewController(nibName: "LoadingViewController", bundle: nil)
        loadingController.view.tag = 123098
        self.present(loadingController, animated: false, completion: nil)
    }
    
    func hideLoading(_ error:String?) -> Void {
        if self.presentedViewController != nil && self.presentedViewController!.view.tag == 123098 {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
