//
//  PerformancesTableViewController.swift
//  MobileRoadie
//
//  Created by Bradley Spaulding on 8/3/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

import Foundation
import UIKit

class PerformancesTableViewController : UITableViewController {
  var performances : [Performance] = []
  let performanceStore = singletons.performanceStore
  var selectedPerformance : Performance?
  
  @IBAction func addPerformance(sender: AnyObject) {
    performanceStore.create(Performance())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    performances = performanceStore.performances()
    performanceStore.register({
      self.performances = self.performanceStore.performances()
      self.tableView.reloadData()
    })
  }
  
  override func numberOfSectionsInTableView(tableView:UITableView) -> NSInteger {
    return 1
  }
  
  override func tableView(tableView:UITableView, numberOfRowsInSection section:NSInteger) -> NSInteger {
    if (performances.count == 0) {
      return 1;
    } else {
      return performances.count;
    }
  }

  override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("performancesTableViewCell", forIndexPath:indexPath) as UITableViewCell
    
    if (performances.count == 0) {
      cell.textLabel!.text = "No Performances";
    } else {
      let performance = performances[indexPath.row]
      cell.textLabel!.text = performance.name
    }
    
    return cell;
  }

  override func tableView(tableView:UITableView, willSelectRowAtIndexPath indexPath:NSIndexPath) -> NSIndexPath? {
    if (indexPath.row >= performances.count) {
      return nil
    }
    
    selectedPerformance = performances[indexPath.row]
    return indexPath
  }
  
  override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?) {
    if (segue.identifier == "ShowPerformanceDetail") {
      if let selectedPerformance = selectedPerformance {
        let controller = segue.destinationViewController as! PerformanceDetailViewController
        controller.performance = selectedPerformance
      }
    }
  }
}
