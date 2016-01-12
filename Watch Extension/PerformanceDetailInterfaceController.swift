import WatchKit
import Foundation


class PerformanceDetailInterfaceController: WKInterfaceController {
  @IBOutlet var performanceNameLabel: WKInterfaceLabel!
  @IBOutlet var playButton: WKInterfaceButton!
  
  var performance : [String: String]?
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    performance = context as! [String: String]
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
    performanceNameLabel.setText(performance!["name"])
  }
}