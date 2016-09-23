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
        self.presentViewController(loadingController, animated: false, completion: nil)
    }
    
    func hideLoading(error:String?) -> Void {
        if self.presentedViewController != nil && self.presentedViewController!.view.tag == 123098 {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}