//
//  ProductCollectionViewCell.swift
//  PopMachTest
//
//  Created by Moiz on 12/01/2019.
//  Copyright © 2019 Moiz Ullah. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
}
