//
//  AccountTableViewCell.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 09.04.2024.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
