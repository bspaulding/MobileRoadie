import Foundation
import UIKit

class MIDIDestinationsTableViewController : UITableViewController {
  let midiDestinationStore = singletons.midiDestinationStore
  var destinations : NSArray = [];
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    destinations = midiDestinationStore.destinations()
    print("destinations: \(destinations)")
  
    self.clearsSelectionOnViewWillAppear = false;
  }
  
  override func numberOfSectionsInTableView(tableView:UITableView) -> NSInteger {
    return 1;
  }
  
  override func tableView(tableView:UITableView, numberOfRowsInSection section:NSInteger) -> NSInteger {
    if (destinations.count == 0) {
      return 1;
    } else {
      return destinations.count;
    }
  }
  
  override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("midiDestinationCell", forIndexPath:indexPath) as UITableViewCell
  
    if (destinations.count == 0) {
      cell.textLabel!.text = "No MIDI Outputs";
    } else {
      cell.textLabel!.text = destinations[indexPath.row] as? String;
    }
  
    return cell;
  }
  
  override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    midiDestinationStore.destinationIndex = indexPath.row

    if let navigationController = navigationController {
      navigationController.popViewControllerAnimated(true)
    }
  }
}