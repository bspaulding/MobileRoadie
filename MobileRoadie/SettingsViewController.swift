import Foundation
import UIKit

class SettingsViewController : UITableViewController {
  let midiDestinationStore = singletons.midiDestinationStore
  
  @IBOutlet weak var destinationName: UILabel!
  
  @IBAction func doneTapped(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion:nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.update()
    midiDestinationStore.register({
      self.update()
    })
  }
  
  private func update() {
    destinationName.text = midiDestinationStore.destinationName()
  }
}
