//
//  ViewController.swift
//  SwiftStockExample
//
//  Created by Mike Ackley on 5/3/15.
//  Copyright (c) 2015 Michael Ackley. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    var searchResults: [StockSearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.tableFooterView = UIView() 
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "StockCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "stockCell")
        tableView.rowHeight = 60
        searchBar.delegate = self
        
    }
    
    
    // *** Here's the important bit *** //
    func searchYahooFinanceWithString(searchText: String) {
        
        SwiftStockKit.fetchStocksFromSearchTerm(term: searchText) { (stockInfoArray) -> () in
            
            self.searchResults = stockInfoArray
            self.tableView.reloadData()
            
        }
    
    }
    
    
    
    // Search code
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let length = searchText.characters.count
        
        if length > 0 {
            searchYahooFinanceWithString(searchText)
        } else {
            searchResults.removeAll()
            tableView.reloadData()
        }
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        tableView.reloadData()
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        tableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    
    //SearchBar stuff
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                tableViewBottomConstraint.constant = keyboardHeight
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let _ = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                tableViewBottomConstraint.constant = 0.0
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    //TableView stuff
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let controller: DetailViewController = storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
        controller.stockSymbol = searchResults[indexPath.row].symbol!
        navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: StockCell = tableView.dequeueReusableCellWithIdentifier("stockCell") as! StockCell
            cell.symbolLbl.text = searchResults[indexPath.row].symbol
            cell.companyLbl.text = searchResults[indexPath.row].name
            let exchange = searchResults[indexPath.row].exchange!
            let assetType = searchResults[indexPath.row].assetType!
            cell.infoLbl.text = exchange + "  |  " + assetType
        
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

