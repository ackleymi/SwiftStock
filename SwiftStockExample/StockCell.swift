//
//  StockCell.swift
//  SwiftStockExample
//
//  Created by Mike Ackley on 5/3/15.
//  Copyright (c) 2015 Michael Ackley. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {

    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
