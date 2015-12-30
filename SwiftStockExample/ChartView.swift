//
//  ChartView.swift
//  SwiftStockExample
//
//  Created by Mike Ackley on 5/28/15.
//  Copyright (c) 2015 Michael Ackley. All rights reserved.
//

import UIKit

protocol ChartViewDelegate {

    func didChangeTimeRange(range range: ChartTimeRange)
}

class ChartView: UIView {
    
    @IBOutlet weak var btnIndicatorView: UIView!
    var delegate: ChartViewDelegate!
    
    class func create() -> ChartView {
        let chartView = UINib(nibName: "ChartView", bundle:nil).instantiateWithOwner(nil, options: nil)[0] as! ChartView
        chartView.btnIndicatorView.layer.cornerRadius = 15
        
        return chartView
    }
    
    @IBAction func timeRangeBtnTapped(sender: AnyObject) {
        
        let btn = sender as! UIButton
       
        btnIndicatorView.center = btn.center

        var range: ChartTimeRange = .OneDay
        
        switch btn.tag {
        case 1:
            range = .OneDay
        case 2:
            range = .FiveDays
        case 3:
            range = .TenDays
        case 4:
            range = .OneMonth
        case 5:
            range = .ThreeMonths
        case 6:
            range = .OneYear
        case 7:
            range = .FiveYears
        default:
            range = .OneDay
        }
        delegate.didChangeTimeRange(range: range)
        
        for view in subviews {
            
            if view.isMemberOfClass(UIButton) {
                let subBtn = view as! UIButton
                if btn.tag == subBtn.tag {
                    subBtn.setTitleColor(UIColor(red: (127/255), green: (50/255), blue: (198/255), alpha: 1), forState: .Normal)
                    subBtn.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
                } else {
                    subBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    subBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
                }
                
            }
        
        }
        
        
        
    }
    
    
}
