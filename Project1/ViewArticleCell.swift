//
//  ViewArticleCell.swift
//  Project1
//
//  Created by Artoo on 23/07/16.
//  Copyright © 2016 Gruppo2. All rights reserved.
//

import UIKit

class ViewArticleCell: UITableViewCell {
    
    @IBOutlet weak var articleNameLabel: UILabel!
    
    @IBOutlet weak var articlePriceLabel: UILabel!
    
    
    @IBOutlet weak var articleDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
