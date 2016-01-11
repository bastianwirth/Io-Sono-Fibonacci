//
//  ListViewController.swift
//  Io Sono Fibonacci
//
//  Created by Bastian Wirth on 03.01.16.
//  Copyright © 2016 Bastian Wirth. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "The Fibonacci Sequence"
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        
        let number = appDelegate.fibonacciNumbers[indexPath.row]
        let decimalNumber = NSDecimalNumber(unsignedInteger: number.number)
        cell.selectionStyle = .None
        cell.textLabel!.text = String(number.index)
        cell.detailTextLabel!.text = decimalNumber.stringValue
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.fibonacciNumbers.count
    }
    
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if (action == Selector("copy:")) {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        UIPasteboard.generalPasteboard().string = cell!.detailTextLabel!.text // Copy the Fibonacci number into the pasteboard.
    }

}
