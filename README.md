![banner](assets/banner.png)

`SwiftStock` is the simplest way to add real-time <a href="http://finance.yahoo.com">Yahoo! Finance</a> stock market data to your Swift app. It's a major Swift upgrade for my previous contribution <a href="https://github.com/ackleymi/MAStockGraph">MAStockGRaph</a>. For simplicity, the example project I built using the library has the <a href="https://github.com/Alamofire/Alamofire">Alamofire</a> swift file included for accessing the Yahoo Finance APIs. (no need to run carthage or cocoapods, it runs out of the box)

`SwiftStock` consists of three parts- 1) A predictive stock quote search API. 2) A comprehensive financial instrument API with all the best data :D. 3) A charting API that yields a full set of time-and-sales data over various time frames (including the elusive intraday)

![demo](assets/demo.gif)

## Requirements

`SwiftStock` uses Swift 1.2 with ARC and requires iOS 8.0+. 

## Installation

### Manual

Copy the swift file `SwiftStockKit` to your project and have Alamofire installed.

## Usage

The pull-to-refresh only takes a few lines to add to your view controller. You can directly customize the functionality in the category file if you wish. 

#### Example
This code

```swift

- (void)viewDidLoad {
[super viewDidLoad];
// Do any additional setup after loading the view, typically from a nib.
self.tableView.delegate = self;
self.tableView.dataSource = self;

__weak typeof(self) weakSelf =self;
[self.tableView addPullToRefreshWithActionHandler:^{

//Call your method here
[weakSelf startRefreshing];

}];


}

-(void)startRefreshing{

//terminate the refresh after 2 seconds. place 'stopAnimating' after your refresh is completed

__weak typeof(self) weakSelf =self;
int64_t delayInSeconds = 2.0;
dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

//Stop the refresh by calling this method
[weakSelf.tableView.pullToRefreshView stopAnimating];

});
}
```
## License

The MIT License (MIT)

Copyright (c) 2015 Michael Ackley

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.