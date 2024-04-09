//
//  BasketTableViewCell.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 27.03.2024.
//

import UIKit

class BasketTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton : UIButton!
    @IBOutlet weak var minusButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
