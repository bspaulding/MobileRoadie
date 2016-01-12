import UIKit

class FileListViewController : UITableViewController {
  let cellIdentifier = "fileListCell"
  var files : [String] = []
  let sharedFilesStore = SharedFilesStore()
  let performanceStore = singletons.performanceStore
  var showAudioFiles = true
  var showMidiFiles = true
  var performance : Performance? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if (showAudioFiles && !showMidiFiles) {
      navigationItem.title = "Select Audio File"
      files = sharedFilesStore.audioFiles()
    } else if (showMidiFiles && !showAudioFiles) {
      navigationItem.title = "Select MIDI File"
      files = sharedFilesStore.midiFiles()
    }
  }

  override func tableView(tableView:UITableView, numberOfRowsInSection section:NSInteger) -> NSInteger {
    if (files.count == 0) {
      return 1;
    } else {
      return files.count;
    }
  }
  
  override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as UITableViewCell
    
    if (files.count == 0) {
      cell.textLabel!.text = "No files";
    } else {
      cell.textLabel!.text = files[indexPath.row]
    }
    
    return cell;
  }
  
  override func tableView(tableView:UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    print("didSelectRowAtIndexPath: performance: \(performance)")
    if let performance = performance {
      let filename = files[indexPath.row]
      
      if (showAudioFiles && !showMidiFiles) {
        performance.originalAudioFileName = filename
      } else if (showMidiFiles && !showAudioFiles) {
        performance.originalMidiFileName = filename
      }
      
      performanceStore.update(performance)
    }
    
    if let navigationController = navigationController {
      navigationController.popViewControllerAnimated(true)
    }
  }
}