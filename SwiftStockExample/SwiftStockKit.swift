//
//  SwiftStockKit.swift
//  SwiftStockExample
//
//  Created by Mike Ackley on 5/3/15.
//  Copyright (c) 2015 Michael Ackley. All rights reserved.
//

import UIKit

struct StockSearchResult {
    var symbol: String?
    var name: String?
    var exchange: String?
    var assetType: String?
}

struct Stock {
    
    var ask: String?
    var averageDailyVolume: String?
    var bid: String?
    var bookValue: String?
    var changeNumeric: String?
    var changePercent: String?
    var dayHigh: String?
    var dayLow: String?
    var dividendShare: String?
    var dividendYield: String?
    var ebitda: String?
    var epsEstimateCurrentYear: String?
    var epsEstimateNextQtr: String?
    var epsEstimateNextYr: String?
    var eps: String?
    var fiftydayMovingAverage: String?
    var lastTradeDate: String?
    var last: String?
    var lastTradeTime: String?
    var marketCap: String?
    var companyName: String?
    var oneYearTarget: String?
    var open: String?
    var pegRatio: String?
    var peRatio: String?
    var previousClose: String?
    var priceBook: String?
    var priceSales: String?
    var shortRatio: String?
    var stockExchange: String?
    var symbol: String?
    var twoHundreddayMovingAverage: String?
    var volume: String?
    var yearHigh: String?
    var yearLow: String?
    
    var dataFields: [[String : String]]
    
}

struct ChartPoint {
    var date: NSDate?
    var volume: Int?
    var open: CGFloat?
    var close: CGFloat?
    var low: CGFloat?
    var high: CGFloat?

}

enum ChartTimeRange {
    case OneDay, FiveDays, TenDays, OneMonth, ThreeMonths, OneYear, FiveYears
}



class SwiftStockKit {
    
    class func fetchStocksFromSearchTerm(#term: String, completion:(stockInfoArray: [StockSearchResult]) -> ()) {
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            var searchURL = "http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=\(term)&callback=YAHOO.Finance.SymbolSuggest.ssCallback"
            
            request(.GET, searchURL)
                .responseString { (_, response, resultString, _) in
                   
                    if response?.statusCode == 200 {
                        
                        //Bummer that Yahoo Finance requires a JSONP callback function be included. Remove it!
                        var jsonString = resultString! as NSString
                            jsonString = jsonString.substringFromIndex(39)
                            jsonString = jsonString.substringToIndex(jsonString.length-1)
                        
                        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                            if let resultJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [String : AnyObject] {

                                let jsonArray = (resultJSON["ResultSet"] as! [String : AnyObject])["Result"]! as! [[String : String]]
                                var stockInfoArray = [StockSearchResult]()
                                
                                for dictionary in jsonArray {
                                    stockInfoArray.append(StockSearchResult(symbol: dictionary["symbol"], name: dictionary["name"], exchange: dictionary["exchDisp"], assetType: dictionary["typeDisp"]))
                                }
                                dispatch_async(dispatch_get_main_queue()) {
                                    completion(stockInfoArray: stockInfoArray)
                                }
                            }
                        }
                    }
            }
        }
    }
    
    class func fetchStockForSymbol(#symbol: String, completion:(stock: Stock) -> ()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
            var stockURL = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22\(symbol)%22)&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&format=json"
            
            request(.GET, stockURL)
                .responseJSON { (_, response, resultsJSON, _) in
               
                if response?.statusCode == 200 {
                    
                    if let stockData = (((resultsJSON as! [String : AnyObject])["query"] as! [String : AnyObject])["results"] as! [String : AnyObject])["quote"] as? [String : AnyObject] {
                    
                        // lengthy creation, yeah
                        var dataFields = [[String : String]]()
                        
                        dataFields.append(["Ask" : stockData["Ask"] as? String ?? "N/A"])
                        dataFields.append(["Average Daily Volume" : stockData["AverageDailyVolume"] as? String ?? "N/A"])
                        dataFields.append(["Bid" : stockData["Bid"] as? String ?? "N/A"])
                        dataFields.append(["Book Value" : stockData["BookValue"] as? String ?? "N/A"])
                        dataFields.append(["Change" : stockData["Change"] as? String ?? "N/A"])
                        dataFields.append(["Percent Change" : stockData["ChangeinPercent"] as? String ?? "N/A"])
                        dataFields.append(["Day High" : stockData["DaysHigh"] as? String ?? "N/A"])
                        dataFields.append(["Day Low" : stockData["DaysLow"] as? String ?? "N/A"])
                        dataFields.append(["Div/Share" : stockData["DividendShare"] as? String ?? "N/A"])
                        dataFields.append(["Div Yield" : stockData["DividendYield"] as? String ?? "N/A"])
                        dataFields.append(["EBITDA" : stockData["EBITDA"] as? String ?? "N/A"])
                        dataFields.append(["Current Yr EPS Estimate" : stockData["EPSEstimateCurrentYear"] as? String ?? "N/A"])
                        dataFields.append(["Next Qtr EPS Estimate" : stockData["EPSEstimateNextQuarter"] as? String ?? "N/A"])
                        dataFields.append(["Next Yr EPS Estimate" : stockData["EPSEstimateNextYear"] as? String ?? "N/A"])
                        dataFields.append(["Earnings/Share" : stockData["EarningsShare"] as? String ?? "N/A"])
                        dataFields.append(["50D MA" : stockData["FiftydayMovingAverage"] as? String ?? "N/A"])
                        dataFields.append(["Last Trade Date" : stockData["LastTradeDate"] as? String ?? "N/A"])
                        dataFields.append(["Last" : stockData["LastTradePriceOnly"] as? String ?? "N/A"])
                        dataFields.append(["Last Trade Time" : stockData["LastTradeTime"] as? String ?? "N/A"])
                        dataFields.append(["Market Cap" : stockData["MarketCapitalization"] as? String ?? "N/A"])
                        dataFields.append(["Company" : stockData["Name"] as? String ?? "N/A"])
                        dataFields.append(["One Yr Target" : stockData["OneyrTargetPrice"] as? String ?? "N/A"])
                        dataFields.append(["Open" : stockData["Open"] as? String ?? "N/A"])
                        dataFields.append(["PEG Ratio" : stockData["PEGRatio"] as? String ?? "N/A"])
                        dataFields.append(["PE Ratio" : stockData["PERatio"] as? String ?? "N/A"])
                        dataFields.append(["Previous Close" : stockData["PreviousClose"] as? String ?? "N/A"])
                        dataFields.append(["Price-Book" : stockData["PriceBook"] as? String ?? "N/A"])
                        dataFields.append(["Price-Sales" : stockData["PriceSales"] as? String ?? "N/A"])
                        dataFields.append(["Short Ratio" : stockData["ShortRatio"] as? String ?? "N/A"])
                        dataFields.append(["Stock Exchange" : stockData["StockExchange"] as? String ?? "N/A"])
                        dataFields.append(["Symbol" : stockData["Symbol"] as? String ?? "N/A"])
                        dataFields.append(["200D MA" : stockData["TwoHundreddayMovingAverage"] as? String ?? "N/A"])
                        dataFields.append(["Volume" : stockData["Volume"] as? String ?? "N/A"])
                        dataFields.append(["52w High" : stockData["YearHigh"] as? String ?? "N/A"])
                        dataFields.append(["52w Low" : stockData["YearLow"] as? String ?? "N/A"])

                        let stock = Stock(
                            ask: dataFields[0].values.array[0],
                            averageDailyVolume: dataFields[1].values.array[0],
                            bid: dataFields[2].values.array[0],
                            bookValue: dataFields[3].values.array[0],
                            changeNumeric: dataFields[4].values.array[0],
                            changePercent: dataFields[5].values.array[0],
                            dayHigh: dataFields[6].values.array[0],
                            dayLow: dataFields[7].values.array[0],
                            dividendShare: dataFields[8].values.array[0],
                            dividendYield: dataFields[9].values.array[0],
                            ebitda: dataFields[10].values.array[0],
                            epsEstimateCurrentYear: dataFields[11].values.array[0],
                            epsEstimateNextQtr: dataFields[12].values.array[0],
                            epsEstimateNextYr: dataFields[13].values.array[0],
                            eps: dataFields[14].values.array[0],
                            fiftydayMovingAverage: dataFields[15].values.array[0],
                            lastTradeDate: dataFields[16].values.array[0],
                            last: dataFields[17].values.array[0],
                            lastTradeTime: dataFields[18].values.array[0],
                            marketCap: dataFields[19].values.array[0],
                            companyName: dataFields[20].values.array[0],
                            oneYearTarget: dataFields[21].values.array[0],
                            open: dataFields[22].values.array[0],
                            pegRatio: dataFields[23].values.array[0],
                            peRatio: dataFields[24].values.array[0],
                            previousClose: dataFields[25].values.array[0],
                            priceBook: dataFields[26].values.array[0],
                            priceSales: dataFields[27].values.array[0],
                            shortRatio: dataFields[28].values.array[0],
                            stockExchange: dataFields[29].values.array[0],
                            symbol: dataFields[30].values.array[0],
                            twoHundreddayMovingAverage: dataFields[31].values.array[0],
                            volume: dataFields[32].values.array[0],
                            yearHigh: dataFields[33].values.array[0],
                            yearLow: dataFields[34].values.array[0],
                            dataFields: dataFields
                        )
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(stock: stock)
                        }
                    }
                }
            }
        }
    }
   
    class func fetchChartPoints(#symbol: String, range: ChartTimeRange, completion:(chartPoints: [ChartPoint]) -> ()) {
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            //An Alamofire regular responseJSON wont parse the JSONP with a callback wrapper correctly, so lets work around that
            var chartURL = SwiftStockKit.chartUrlForRange(symbol, range: range)
            request(.GET, chartURL).response() {
                (request, response, data, error) in
  
               if response?.statusCode == 200 {
                    
                    var jsonString =  NSString(data: data as! NSData, encoding: NSUTF8StringEncoding)!
                    jsonString = jsonString.substringFromIndex(30)
                    jsonString = jsonString.substringToIndex(jsonString.length-1)
                    
                    if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                        if let resultJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [String : AnyObject] {
                        
                            let series = resultJSON["series"] as! [[String : AnyObject]]
                            var chartPoints = [ChartPoint]()
                            for dataPoint in series {
                                //GMT off by 4 hrs
                                 let date = NSDate(timeIntervalSince1970: (dataPoint["Timestamp"] as? Double ?? dataPoint["Date"] as! Double) - 14400.0)
                                
                                chartPoints.append(
                                    ChartPoint(
                                    date:  date,
                                    volume: dataPoint["volume"] as? Int,
                                    open: dataPoint["open"] as? CGFloat,
                                    close: dataPoint["close"] as? CGFloat,
                                    low: dataPoint["low"] as? CGFloat,
                                    high: dataPoint["high"] as? CGFloat
                                    )
                                )
                            }
                            dispatch_async(dispatch_get_main_queue()) {
                                 completion(chartPoints: chartPoints)
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func chartUrlForRange(symbol: String, range: ChartTimeRange) -> String {
    
        var timeString = String()
        
        switch (range) {
        case .OneDay:
            timeString = "1d"
        case .FiveDays:
            timeString = "5d"
        case .TenDays:
            timeString = "10d"
        case .OneMonth:
            timeString = "1m"
        case .ThreeMonths:
            timeString = "3m"
        case .OneYear:
            timeString = "1y"
        case .FiveYears:
            timeString = "5y"
        }
        
        return "http://chartapi.finance.yahoo.com/instrument/1.0/\(symbol)/chartdata;type=quote;range=\(timeString)/json"
    }

}


class SwiftStockChart: UIView {
    
    enum ValueLabelPositionType {
        case Left, Right, Mirrored
    }
    
    typealias LabelForIndexGetter = (index: NSInteger) -> String
    typealias LabelForValueGetter = (value: CGFloat) -> String

    //Index Label Properties
    var labelForIndex: LabelForIndexGetter!
    var indexLabelFont: UIFont?
    var indexLabelTextColor: UIColor?
    var indexLabelBackgroundColor: UIColor?
    
    // Value label properties
    //var labelForIndex
    var labelForValue: LabelForValueGetter!
    var valueLabelFont: UIFont?
    var valueLabelTextColor: UIColor?
    var valueLabelBackgroundColor: UIColor?
    var valueLabelPosition: ValueLabelPositionType?
    
    // Number of visible step in the chart
    var gridStep: Int?
    var verticalGridStep: Int?
    var horizontalGridStep: Int?

    // Margin of the chart
    var margin: CGFloat?
    
    var axisWidth: CGFloat?
    var axisHeight: CGFloat?

    // Decoration parameters, let you pick the color of the line as well as the color of the axis
    var axisColor: UIColor?
    var axisLineWidth: CGFloat?
    
    // Chart parameters
    var color: UIColor?
    var fillColor: UIColor?
    var lineWidth: CGFloat?
    
    // Data points
    var displayDataPoint: Bool?
    var dataPointColor: UIColor?
    var dataPointBackgroundColor: UIColor?
    var dataPointRadius: CGFloat?
    
    // Grid parameters
    var drawInnerGrid: Bool?
    var innerGridColor: UIColor?
    var innerGridLineWidth: CGFloat?
    // Smoothing
    var bezierSmoothing: Bool?
    var bezierSmoothingTension: CGFloat?
    
    // Animations
    var animationDuration: CGFloat?

    var timeRange: ChartTimeRange!
    var dataPoints = [ChartPoint]()
    var layers = [CAShapeLayer]()
    var axisLabels = [UILabel]()
    var minValue: CGFloat?
    var maxValue: CGFloat?
    var initialPath: CGMutablePathRef?
    var newPath: CGMutablePathRef?

    
    //Implementation
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        color = UIColor.greenColor()
        fillColor = color?.colorWithAlphaComponent(0.25)
        verticalGridStep = 3
        horizontalGridStep = 3
        margin = 5.0
        axisWidth = self.frame.size.width - 2 * margin!
        axisHeight = self.frame.size.height - 2 * margin!
        axisColor = UIColor(white: 0.5, alpha: 1.0)
        innerGridColor = UIColor(white: 0.9, alpha: 1.0)
        drawInnerGrid = false
        bezierSmoothing = false
        bezierSmoothingTension = 0.2
        lineWidth = 1
        innerGridLineWidth = 0.5
        axisLineWidth = 1
        animationDuration = 0.0
        displayDataPoint = false
        dataPointRadius = 1.0
        dataPointColor = color
        dataPointBackgroundColor = color
        
        indexLabelBackgroundColor = UIColor.clearColor()
        indexLabelTextColor = UIColor(white: 1, alpha: 0.6)
        indexLabelFont = UIFont(name: "HelveticaNeue-Light", size: 10)
        
        valueLabelBackgroundColor = UIColor.clearColor()
        valueLabelTextColor = UIColor(white: 1, alpha: 0.6)
        valueLabelFont = UIFont(name: "HelveticaNeue-Light", size: 11)
        valueLabelPosition = .Right
        

    }
    
    func setChartPoints(#points: [ChartPoint]) {
    
        if points.isEmpty { return }
        
        dataPoints = points
    
        computeBounds()
        
        
        if maxValue!.isNaN { maxValue = 1.0 }
        
        for var i = 0; i < verticalGridStep!; i++ {
            
            let yVal = axisHeight! + margin! - CGFloat((i + 1)) * axisHeight! / CGFloat(verticalGridStep!)
            let p = CGPointMake((valueLabelPosition! == .Right ? axisWidth! : 0), yVal)
            
            let text = labelForValue(value: minValue! + (maxValue! - minValue!) / CGFloat(verticalGridStep!) * CGFloat((i + 1)))
            
            let rect = CGRectMake(margin!,  p.y + 2, self.frame.size.width - margin! * 2 - 4.0, 14.0)
            let width = text.boundingRectWithSize(rect.size,
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes:[NSFontAttributeName : valueLabelFont!],
                context: nil).size.width
            
            let xPadding = 6
            let xOffset = width + CGFloat(xPadding)
            
            var label = UILabel(frame: CGRectMake(p.x - xOffset + 5.0, p.y, width + 2, 14))
            label.text = text
            label.font = valueLabelFont
            label.textColor = valueLabelTextColor
            label.textAlignment = .Center
            label.backgroundColor = valueLabelBackgroundColor!
            
            self.addSubview(label)
            axisLabels.append(label)
        
        }
        
        for var i = 0; i < horizontalGridStep! + 1; i++ {
            
            let text = labelForIndex(index: i)
            
            let p = CGPointMake(margin! + CGFloat(i) * (axisWidth! / CGFloat(horizontalGridStep!)) * 1.0, axisHeight! + margin!)
            
        
            let rect = CGRectMake(margin!, p.y + 2, self.frame.size.width - margin! * 2 - 4.0, 14)
            let width = text.boundingRectWithSize(rect.size,
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes:[NSFontAttributeName : indexLabelFont!],
                context: nil).size.width
            
            let xPadding = 6
            let xOffset = width + CGFloat(xPadding)
            
            var label = UILabel(frame: CGRectMake(p.x - 5.0, p.y + 5.0, width + 2, 14))
            label.text = text
            label.font = indexLabelFont!
            label.textAlignment = .Left
            label.textColor = indexLabelTextColor!
            label.backgroundColor = indexLabelBackgroundColor!
            
            self.addSubview(label)
            axisLabels.append(label)
        
        }
        
        self.color = UIColor.whiteColor()
            //UIColor(red: (127/255), green: (50/255), blue: (198/255), alpha: 1)
        strokeChart()
        self.setNeedsDisplay()
    
    }
    
    override func drawRect(rect: CGRect) {
        if !dataPoints.isEmpty {
            drawGrid()
        }
    }
    
    func drawGrid() {
        
        if drawInnerGrid! {
            
            let ctx = UIGraphicsGetCurrentContext()
            UIGraphicsPushContext(ctx)
            CGContextSetLineWidth(ctx, axisLineWidth!)
            CGContextSetStrokeColorWithColor(ctx, axisColor!.CGColor)
            
            CGContextMoveToPoint(ctx, margin!, margin!)
            CGContextAddLineToPoint(ctx, margin!, axisHeight! + margin! + 3)
            CGContextStrokePath(ctx)
            
            for var i = 0; i < horizontalGridStep!; i++ {
                
                CGContextSetStrokeColorWithColor(ctx, innerGridColor!.CGColor)
                CGContextSetLineWidth(ctx, innerGridLineWidth!)
                
                let point = CGPointMake(CGFloat((1 + i)) * axisWidth! / CGFloat(horizontalGridStep!) * 1.0 + margin!, margin!)
                
                CGContextMoveToPoint(ctx, point.x, point.y)
                CGContextAddLineToPoint(ctx, point.x, axisHeight! + margin!)
                CGContextStrokePath(ctx)
                
                CGContextSetStrokeColorWithColor(ctx, axisColor!.CGColor)
                CGContextSetLineWidth(ctx, axisLineWidth!)
                CGContextMoveToPoint(ctx, point.x - 0.5, axisHeight! + margin!)
                CGContextAddLineToPoint(ctx, point.x - 0.5, axisHeight! + margin! + 3)
                CGContextStrokePath(ctx)
            
            }
        
            for var i = 0; i < verticalGridStep! + 1; i++ {
                
                let v = maxValue! - (maxValue! - minValue!) / CGFloat(verticalGridStep! * i)
                
                if(v == minValue!) {
                    CGContextSetLineWidth(ctx, axisLineWidth!)
                    CGContextSetStrokeColorWithColor(ctx, axisColor!.CGColor)
                } else {
                    CGContextSetStrokeColorWithColor(ctx, innerGridColor!.CGColor)
                    CGContextSetLineWidth(ctx, innerGridLineWidth!)
                }
                
                let point = CGPointMake(margin!, CGFloat(i) * axisHeight! / CGFloat(verticalGridStep!) + margin!)
                
                CGContextMoveToPoint(ctx, point.x, point.y)
                CGContextAddLineToPoint(ctx, axisWidth! + margin!, point.y)
                CGContextStrokePath(ctx)
                
            }
        }
    
    }
    
    func clearChartData(){
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        layers.removeAll()
        
        for lbl in axisLabels {
            lbl.removeFromSuperview()
        }
        axisLabels.removeAll()
    }
    
    func strokeChart(){
        
        let scale = axisHeight! / (maxValue! - minValue!)
        
        let path = getLinePath(scale: scale, smoothing: bezierSmoothing!, close: false)
        
        var pathLayer = CAShapeLayer()
        pathLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + (margin! * 1.2), self.bounds.size.width, self.bounds.size.height)
        pathLayer.bounds = self.bounds
        pathLayer.path = path.CGPath
        pathLayer.fillColor = nil
        pathLayer.strokeColor = color!.CGColor
        pathLayer.lineWidth = lineWidth!
        pathLayer.lineJoin = kCALineJoinRound
        
        self.layer.addSublayer(pathLayer)
        layers.append(pathLayer)
    
    }
    
    func computeBounds(){
        minValue = CGFloat(MAXFLOAT)
        maxValue = CGFloat(-MAXFLOAT)
        
        for var i = 0; i < dataPoints.count; i++ {
            let value = dataPoints[i].close!
         
            if value < minValue! {
                minValue = value
            }
            
            if value > maxValue! {
                maxValue = value
            }

          //  maxValue = getUpperRoundNumber(value: maxValue!, gridStep: verticalGridStep!)
            
            if minValue! < 0 {
            
                var step: CGFloat
                
                if verticalGridStep! > 3 {
                    step = fabs(maxValue! - minValue!) / CGFloat(verticalGridStep! - 1)
                } else {
                    step = max(fabs(maxValue! - minValue!) / 2, max(fabs(minValue!), fabs(maxValue!)))
                }
                
                step = getUpperRoundNumber(value: step, gridStep: verticalGridStep!)
                
                var newMin: CGFloat
                var newMax: CGFloat

                if fabs(minValue!) > fabs(maxValue!) {
                    let m = ceil(fabs(minValue!) / step)
                   
                    newMin = step * m * (minValue! > 0 ? 1 : -1)
                    newMax = step * (CGFloat(verticalGridStep!) - m) * (maxValue! > 0 ? 1 : -1)
                } else {
                    let m = ceil(fabs(maxValue!) / step)
                    
                    newMax = step * m * (maxValue! > 0 ? 1 : -1)
                    newMin = step * (CGFloat(verticalGridStep!) - m) * (minValue! > 0 ? 1 : -1)
                }
                
                if(minValue! < newMin) {
                    newMin -= step
                    newMax -=  step
                }
                
                if(maxValue! > newMax + step) {
                    newMin += step
                    newMax += step
                }
                
                minValue = newMin
                maxValue = newMax
                
                if(maxValue! < minValue!) {
                    let tmp = maxValue!
                    maxValue = minValue
                    minValue = tmp
                }
                
            }
        }
    }
    
    func getUpperRoundNumber(#value: CGFloat, gridStep: Int) -> CGFloat {
        if value <= 0.0 {
            return 0.0
        }
        
        let logValue = log10f(Float(value))
        let scale = powf(10.0, floorf(logValue))
        var n = ceil(value / CGFloat(scale * 4))
        
        let tmp = Int(n) % gridStep
        
        if tmp != 0 {
            n += CGFloat(gridStep - tmp)
        }
        
        return n * CGFloat(scale) / 4.0
    }
    
    func setGridStep(#gridStep: Int) {
        verticalGridStep = gridStep
        horizontalGridStep = gridStep
    }
    
    func getPointForData(#index: Int, scale: CGFloat) -> CGPoint {
        if index < 0 || index >= dataPoints.count{
            return CGPointZero
        }
        
        let dataPoint = dataPoints[index].close!
        
        var properWidth = axisWidth!
        if timeRange! == .OneDay {
            properWidth = ((CGFloat(dataPoints.count) / 391.0) * axisWidth!) - margin!
        }
        
        var xDenom = CGFloat(dataPoints.count - 1)
        if xDenom == 0 { xDenom = 1 }
        
        var yDenom = maxValue! - minValue!
        if yDenom == 0 { yDenom = 0 }
        
        let pt = CGPointMake(
            margin! + CGFloat(index) * ( properWidth / xDenom ),
            ( axisHeight! - (( (dataPoint - minValue!) / yDenom ) * axisHeight!) ) + margin!
        
        )
        
        return pt
        
        // for % based charts
//        var xValue = margin! + CGFloat(index) * (properWidth / CGFloat(dataPoints.count - 1))
//        let startingPoint = maxValue! / (maxValue! + fabs(minValue!))
//        
//        var yValue = (axisHeight! * startingPoint) - ((CGFloat(dataPoint) / ((maxValue! + fabs(minValue!)) * startingPoint)) * (axisHeight! * startingPoint))
//        
//        let isYNan = isnan(yValue)
//        if isYNan { yValue = 0.0 }
//        
//        let isXNan = isnan(xValue)
//        if isXNan { xValue = 0.0 }
//        
//        CGPointMake(xValue,yValue)
        
        
    }
    
    func getLinePath(#scale: CGFloat, smoothing: Bool, close: Bool) -> UIBezierPath {
    
        var path = UIBezierPath()

        for var i = 0; i < dataPoints.count; i++ {
            if i > 0 {
                path.addLineToPoint(getPointForData(index: i, scale: scale))
            } else {
                path.moveToPoint(getPointForData(index: i, scale: scale))
            }
        }
        
        return path
    }
    
    
    func timeLabelsForTimeFrame(range: ChartTimeRange) -> [String] {
    
        switch range {
        case .OneDay:
            return ["9:30am", "10", "11", "12pm", "1", "2", "3", "4"]
        case .FiveDays:
            
           let weekday = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.CalendarUnitWeekday, fromDate: NSDate()).weekday
           switch weekday {
           case 1:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           case 2:
            return ["Tues", "Wed", "Thu", "Fri", "Mon"]
           case 3:
             return ["Wed", "Thu", "Fri", "Mon", "Tues"]
           case 4:
            return ["Thu", "Fri", "Mon", "Tues", "Wed"]
           case 5:
            return ["Fri", "Mon", "Tues", "Wed", "Thu"]
           case 6:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           case 7:
            return ["Mon", "Tues", "Wed", "Thu", "Fri"]
           default: ()
           }
        case .TenDays:
            let weekday = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.components(.CalendarUnitWeekday, fromDate: NSDate()).weekday
            switch weekday {
                //sunday
            case 1:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
            case 2:
                return ["Wed", "Fri", "Mon", "Wed", "Fri", "Mon"]
            case 3:
                return ["Wed", "Fri", "Mon", "Wed", "Fri", "Tues"]
            case 4:
                return ["Fri", "Mon", "Wed", "Fri", "Mon", "Wed"]
            case 5:
                return ["Wed", "Mon", "Wed", "Fri", "Tues", "Thu"]
            case 6:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
                //saturday
            case 7:
                return ["Mon", "Wed", "Fri", "Mon", "Wed", "Fri"]
            default: ()
            }
        case .OneMonth:
            
            var fmt = NSDateFormatter()
            fmt.dateFormat = "dd MMM"
            let offset = Double(-6*24*60*60)
            let start = NSDate()
            let fifthString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset))
            let fourthString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 2))
            let thirdString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 3))
            let secondString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 4))
            let firstString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]
        case .ThreeMonths:
            var fmt = NSDateFormatter()
            fmt.dateFormat = "dd MMM"
            let offset = Double(-15*24*60*60)
            let start = NSDate()
            let fifthString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset))
            let fourthString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 2))
            let thirdString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 3))
            let secondString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 4))
            let firstString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]
        case .OneYear:
            var fmt = NSDateFormatter()
            fmt.dateFormat = "MMM"
            let offset = Double(-80*24*60*60)
            let start = NSDate()
            let fifthString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset))
            let fourthString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 2))
            let thirdString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 3))
            let secondString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 4))
            let firstString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]

        case .FiveYears:
            var fmt = NSDateFormatter()
            fmt.dateFormat = "yyyy"
            let offset = Double(-365*24*60*60)
            let start = NSDate()
            let fifthString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset))
            let fourthString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 2))
            let thirdString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 3))
            let secondString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 4))
            let firstString = fmt.stringFromDate(start.dateByAddingTimeInterval(offset * 5))
            
            return[firstString, secondString, thirdString, fourthString, fifthString, ""]

        default: ()
        }
        return []
    }
}
















