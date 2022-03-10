//
//  CardColorCell.swift
//  Cards
//
//  Created by Pavel Yarovoi on 09.03.2022.
//

import UIKit

class CardColorCell: UITableViewCell {
    
    @IBOutlet var cardColor: UILabel!
    @IBOutlet var cardColorName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
