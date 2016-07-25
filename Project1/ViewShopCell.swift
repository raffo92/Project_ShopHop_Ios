//
//  ViewList.swift
//  Project1
//
//  Created by Raffaele P on 21/07/16.
//  Copyright © 2016 Gruppo2. All rights reserved.
//

import UIKit

class ViewShopCell: UITableViewCell {

    @IBOutlet var shopImageCell: UIImageView!
    @IBOutlet var shopNameCell: UILabel!
    @IBOutlet var shopNumberArtCell: UILabel!
    @IBOutlet var shopPriceCell: UILabel!
    
    @IBOutlet weak var shopStars: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
