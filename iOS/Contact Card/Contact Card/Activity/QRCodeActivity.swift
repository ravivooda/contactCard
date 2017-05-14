//
//  QRCodeActivity.swift
//  QRCode
//
//  Created by Ravi Vooda on 5/10/17.
//  Copyright © 2017 Alexander Schuch. All rights reserved.
//

import UIKit
import QRCode
import CloudKit

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
    
    public init(storyBoard:UIStoryboard) {
        self.qrCodeViewController = storyBoard.instantiateViewController(withIdentifier: "qrShareViewControllerID") as? QRShareViewController
        super.init()
    }
    
    public override var activityViewController: UIViewController? {
        return qrCodeViewController
    }
    
    private let qrCodeViewController:QRShareViewController?
    
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
            self.qrCodeViewController?.code = qrCode
        } else if let data = data {
            self.qrCodeViewController?.code = QRCode(data)
        } else if let string = string, let qrCode = QRCode(string) {
            self.qrCodeViewController?.code = qrCode
        }
    }
}
