//
//  PromoDetailViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 04.04.2024.
//

import Foundation
import UIKit


protocol PromoDetailViewControllerDelegate: AnyObject {
    func promoDetailViewControllerDismissed()
}

class PromoDetailViewController: UIViewController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    weak var delegate: PromoDetailViewControllerDelegate?
    
    var promotion: Promotion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .custom
        if let promotion = promotion {
            bannerImageView.image =  UIImage(named: promotion.imageName)
            eventNameLabel.text = promotion.name
            durationLabel.text = promotion.duration
            eventDescriptionLabel.text = promotion.description
        }
    }
    func setPromotion(_ promotion: Promotion) {
        self.promotion = promotion
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            delegate?.promoDetailViewControllerDismissed()
            
        }
    }
}
