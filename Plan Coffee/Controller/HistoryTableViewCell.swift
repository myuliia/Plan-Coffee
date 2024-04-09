//
//  HistoryTableViewCell.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 01.04.2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bubleView: UIView!
    @IBOutlet weak var totalSum: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        totalSumLabel.text = K.Loc.totalSumLabel
        dateAndTimeLabel.text = K.Loc.dateAndTimeLabel
        pointsLabel.text = K.Loc.pointsAddedLabel
        
        bubleView.layer.cornerRadius = bubleView.frame.size.height / 6
        let separatorLine = UIView()
        separatorLine.backgroundColor = .systemGray5
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            separatorLine.leadingAnchor.constraint(equalTo: bubleView.leadingAnchor, constant: 5),
            separatorLine.trailingAnchor.constraint(equalTo: bubleView.trailingAnchor, constant: -5),
            separatorLine.topAnchor.constraint(equalTo: timestamp.bottomAnchor, constant: 3),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
