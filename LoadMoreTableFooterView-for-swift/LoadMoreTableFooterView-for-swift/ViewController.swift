//
//  ViewController.swift
//  LoadMoreTableFooterView-for-swift
//
//  Created by zhang on 14-6-18.
//  Copyright (c) 2014 zhang. All rights reserved.
//

import Foundation
import UIKit

let PAGESIZE: Int = 20

class ViewController: UIViewController, LoadMoreTableFooterViewDelegate {
    
    @IBOutlet var tableView: UITableView
    
    var loadMoreFooterView: LoadMoreTableFooterView?
    var loadingMore: Bool = false
    var loadingMoreShowing: Bool = false

    var datas: String[] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize LoadMoreTableFooterView
        if loadMoreFooterView == nil {
            loadMoreFooterView = LoadMoreTableFooterView(frame: CGRectMake(0, tableView.contentSize.height, tableView.frame.size.width, tableView.frame.size.height))
            loadMoreFooterView!.delegate = self
            loadMoreFooterView!.backgroundColor = UIColor.clearColor()
            tableView.addSubview(loadMoreFooterView)
        }
        delayLoadFinish()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if !cell {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        }
        cell!.textLabel.text = datas[indexPath.row]
        
        return cell
        
    }
    
    // Load datas
    func makeDatas() {
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("delayLoadFinish"), userInfo: nil, repeats: false)
    }
    
    func delayLoadFinish() {
        if (loadingMore) {
            doneLoadingMoreTableViewData()
        }
        var itemsCount = 20
        if (itemsCount != PAGESIZE) {
            loadingMoreShowing = false
        } else {
            loadingMoreShowing = true
        }
        if (!loadingMoreShowing) {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        for index in 1 ... 20 {
            var string = "test data \(rand())"
            datas += string
        }
        tableView.reloadData()
    }
    
    // LoadMoreTableFooterViewDelegate
    func loadMoreTableFooterDidTriggerRefresh(view: LoadMoreTableFooterView) {
        loadMoreTableViewDataSource()
    }
    
    func loadMoreTableFooterDataSourceIsLoading(view: LoadMoreTableFooterView) -> Bool {
        return loadingMore
    }
    
    // ViewController function
    func loadMoreTableViewDataSource() {
        loadingMore = true
        makeDatas()
    }
    
    func doneLoadingMoreTableViewData() {
        loadingMore = false
        loadMoreFooterView!.loadMoreScrollViewDataSourceDidFinishedLoading(tableView)
    }
    
    // UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView!)
    {
        if (loadingMoreShowing) {
            loadMoreFooterView!.loadMoreScrollViewDidScroll(scrollView)
        }
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        if (loadingMoreShowing) {
            loadMoreFooterView!.loadMoreScrollViewDidEndDragging(scrollView)
        }
    }
    
}

