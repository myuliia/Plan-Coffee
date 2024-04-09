//
//  CollectionViewCell.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 04.04.2024.
//

import UIKit

class PromoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var labelNameView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bannerImageView.layer.cornerRadius = bannerImageView.bounds.width / 10
        bannerImageView.clipsToBounds = true
        labelNameView.layer.cornerRadius = bannerImageView.layer.cornerRadius
        labelNameView.clipsToBounds = true
    }
    
    func configure(with promotion: Promotion) {
        
        eventNameLabel.text = promotion.name
        bannerImageView.image = UIImage(named: promotion.imageName)
        
        bannerImageView.contentMode = .scaleAspectFill
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
