//
//  StockDataCell.swift
//  SwiftStockExample
//
//  Created by Mike Ackley on 5/5/15.
//  Copyright (c) 2015 Michael Ackley. All rights reserved.
//

import UIKit

class StockDataCell: UICollectionViewCell {
   
    @IBOutlet weak var fieldNameLbl: UILabel!
    @IBOutlet weak var fieldValueLbl: UILabel!
    
    func setData(data: [String : String]) {
        fieldNameLbl.text = data.keys.array.first
        fieldValueLbl.text = data.values.array.first

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
