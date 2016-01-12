import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
  @IBOutlet var performancesTable: WKInterfaceTable!
  
  let performances = [
    ["name": "Blessed Assurance"],
    ["name": "Miraculum (E)"],
    ["name": "Miraculum (Eb)"],
    ["name": "O Holy Angels Sing of Joy"],
    ["name": "Great Is Thy Faithfulness"]
  ]

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    update()
  }

  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
    
    update()
  }

  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  func update() {
    performancesTable.setNumberOfRows(performances.count, withRowType: "PerformancesTableRowController")
    for (var i = 0; i < performances.count; i++) {
      let row = performancesTable.rowControllerAtIndex(i) as! PerformancesTableRowController
      row.performanceNameLabel.setText(performances[i]["name"])
    }
  }
  
  override func table(table: WKInterfaceTable, didSelectRowAtIndex i:Int) {
    print("didSelectRowAtIndex \(i)")
    pushControllerWithName("PerformanceDetailInterfaceController", context: performances[i])
  }
}
