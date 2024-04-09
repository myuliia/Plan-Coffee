//
//  QrCodeViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 21.03.2024.
//

import UIKit
import CoreImage
import Firebase


class QrCodeViewController: UIViewController {
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var points = 0
    
    override func viewDidAppear(_ animated: Bool) {
        
        points = UserDataManager.shared.currentUser?.points ?? 0
        pointsLabel.text = String(describing: points)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        
        let customerID = Auth.auth().currentUser?.uid
        if let qrCodeImage = QRCodeGenerator.generateQRCode(from: customerID ?? "0000") {
            qrCodeImageView.image = qrCodeImage
        }
    }
    
    func addBackgroundImage() {
        let backgroundImage = UIImage(named: K.backgoundWithoutLogo)
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImageView, at: 0)
    }
}


class QRCodeGenerator {
    static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
