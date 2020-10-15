//
//  MobileDataCell.swift
//  DatabaseDemo
//
//  Created by Suman on 29/04/20.
//  Copyright © 2020 Suman. All rights reserved.
//

import UIKit

class MobileDataCell: UITableViewCell, ReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with mobile: Mobile) {
        titleLabel.text = "Title: \(mobile.title ?? "")"
        subcategoryLabel.text = "Subcategory: \(mobile.subcategory ?? "")"
        popularityLabel.text = "Popularity: \(mobile.popularity )"
        priceLabel.text = "Price: \(mobile.price )"
    }
}
