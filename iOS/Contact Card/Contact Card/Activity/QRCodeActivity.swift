//
//  QRCodeActivity.swift
//  QRCode
//
//  Created by Ravi Vooda on 5/10/17.
//  Copyright © 2017 Alexander Schuch. All rights reserved.
//

import UIKit
import QRCode

public class QRCodeActivity : UIActivity {
    public override var activityType: UIActivityType? {
        return UIActivityType.init("QR Code")
    }
    
    public override var activityTitle: String? {
        return "QR Code"
    }
    
    public override var activityImage: UIImage? {
        return UIImage(imageLiteralResourceName: "qr_code")
    }
    
    public override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if item is String || item is Data || item is URL {
                return true
            }
        }
        return false
    }
    
    private class QRCodeViewController : UIViewController {
        var qrCode:QRCode
        let imageView = UIImageView()
        
        init(qrCode:QRCode) {
            self.qrCode = qrCode
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            self.qrCode = QRCode(Foundation.Data())
            super.init(nibName: nil, bundle: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissClicked(sender:)))
            
            self.view.addSubview(self.imageView)
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 15.0).isActive = true
            NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -15.0).isActive = true
            NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: self.imageView, attribute: .height, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint(item: self.imageView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
            self.imageView.contentMode = .scaleAspectFit
        }
        
        func dismissClicked(sender:AnyObject) {
            self.dismiss(animated: true, completion: nil)
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.imageView.image = {
                self.qrCode.size = self.imageView.bounds.size
                qrCode.errorCorrection = .High
                return qrCode.image
            }()
        }
    }
    
    public override var activityViewController: UIViewController? {
        if let qrCodeViewController = self.qrCodeViewController {
            return UINavigationController(rootViewController: qrCodeViewController)
        }
        return nil
    }
    
    private var qrCodeViewController:QRCodeViewController?
    
    public override func prepare(withActivityItems activityItems: [Any]) {
        var string:String?
        var urls = [URL]()
        var data:Foundation.Data?
        
        for item in activityItems {
            if let urlItem = item as? URL {
                urls.append(urlItem)
            } else if let dataItem = item as? Foundation.Data {
                data = dataItem
            } else if let stringItem = item as? String {
                string = stringItem
            }
        }
        
        if urls.count > 0, let qrCode = QRCode(urls[0]) {
            self.qrCodeViewController = QRCodeViewController(qrCode: qrCode)
        } else if let data = data {
            self.qrCodeViewController = QRCodeViewController(qrCode: QRCode(data))
        } else if let string = string, let qrCode = QRCode(string) {
            self.qrCodeViewController = QRCodeViewController(qrCode: qrCode)
        }
    }
}
