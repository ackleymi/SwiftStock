//
//  DetailViewController.swift
//  SwiftStockExample
//
//  Created by Mike Ackley on 5/5/15.
//  Copyright (c) 2015 Michael Ackley. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ChartViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var stockSymbol: String = String()
    var stock: Stock?
    var chartView: ChartView!
    var chart: SwiftStockChart!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = stockSymbol
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "StockDataCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "stockDataCell")
        automaticallyAdjustsScrollViewInsets = false
        
        chartView = ChartView.create()
        chartView.delegate = self
        chartView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.addSubview(chartView)
        
        collectionView.addConstraint(NSLayoutConstraint(item: chartView, attribute: .Height, relatedBy: .Equal, toItem:collectionView, attribute: .Height, multiplier: 1.0, constant: -(collectionView.bounds.size.height - 230)))
        collectionView.addConstraint(NSLayoutConstraint(item: chartView, attribute: .Width, relatedBy: .Equal, toItem:collectionView, attribute: .Width, multiplier: 1.0, constant: 0))
        collectionView.addConstraint(NSLayoutConstraint(item: chartView, attribute: .Top, relatedBy: .Equal, toItem:collectionView, attribute: .Top, multiplier: 1.0, constant: -250))
        collectionView.addConstraint(NSLayoutConstraint(item: chartView, attribute: .Left, relatedBy: .Equal, toItem:collectionView, attribute: .Left, multiplier: 1.0, constant: 0))
        collectionView.contentInset = UIEdgeInsetsMake(250, 0, 0, 0)

        
        chart = SwiftStockChart(frame: CGRectMake(10, 10, chartView.frame.size.width - 20, chartView.frame.size.height - 50))
        chart.fillColor = UIColor.clearColor()
        chart.verticalGridStep = 3
        chartView.addSubview(chart)
        loadChartWithRange(range: .OneDay)

        
        // *** Here's the important bit *** //
        SwiftStockKit.fetchStockForSymbol(symbol: stockSymbol) { (stock) -> () in
            self.stock = stock
            self.collectionView.reloadData()
        }

        
    }
    
 
    
    // *** ChartView stuff *** //
    
    func loadChartWithRange(range range: ChartTimeRange) {
    
        chart.timeRange = range
        
        let times = chart.timeLabelsForTimeFrame(range)
        chart.horizontalGridStep = times.count - 1
        
        chart.labelForIndex = {(index: NSInteger) -> String in
            return times[index]
        }
        
        chart.labelForValue = {(value: CGFloat) -> String in
            return String(format: "%.02f", value)
        }
        
        // *** Here's the important bit *** //
        SwiftStockKit.fetchChartPoints(symbol: stockSymbol, range: range) { (chartPoints) -> () in
            self.chart.clearChartData()
            self.chart.setChartPoints(points: chartPoints)
        }
    
    }
    
    func didChangeTimeRange(range range: ChartTimeRange) {
        loadChartWithRange(range: range)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return  stock != nil ? 18 : 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 17 ? 1 : 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("stockDataCell", forIndexPath: indexPath) as! StockDataCell
        cell.setData(stock!.dataFields[(indexPath.section * 2) + indexPath.row])
        
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: (UIScreen.mainScreen().bounds.size.width/2), height: 44)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
