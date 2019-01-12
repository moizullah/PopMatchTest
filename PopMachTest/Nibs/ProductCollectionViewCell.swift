//
//  ProductCollectionViewCell.swift
//  PopMachTest
//
//  Created by Moiz on 12/01/2019.
//  Copyright © 2019 Moiz Ullah. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Color settings
        self.backgroundColor = Theme.darkBackgroundSubView
        nameLabel.textColor = Theme.lightText
        priceLabel.textColor = Theme.lightText
        dateLabel.textColor = .lightGray
        image.alpha = 0.9

        // Set corner radius
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        // Reset all fields
        image.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        dateLabel.text = nil
    }
}
