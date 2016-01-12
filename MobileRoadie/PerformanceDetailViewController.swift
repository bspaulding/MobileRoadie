import UIKit
import AVFoundation

class PerformanceDetailViewController : UITableViewController, UITextFieldDelegate {
  var performance : Performance?
  let performanceStore = singletons.performanceStore
  let midiDestinationStore = singletons.midiDestinationStore
  var selectingAudioTrack = false
  var selectingMidiTrack = false
  var audioPlayer : AVAudioPlayer?
  var midiPlayer : MIDIFilePlayer?
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var originalAudioFileNameLabel: UILabel!
  @IBOutlet weak var originalMidiFileNameLabel: UILabel!
  @IBOutlet weak var playToggleButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nameField.delegate = self
    
    performanceStore.register({
      if let performance = self.performance {
        self.performance = self.performanceStore.find(performance)
      }
      self.update()
    })
    update()

    // TODO: Update MIDIFilePlayer's device index on change.
    //       Will need to update MIDIFilePlayer to handle this change! :/
//    midiDestinationStore.register({
//    })
  }
  
  func update() {
    if let performance = performance {
      navigationItem.title = performance.name
      nameField.text = performance.name
      originalAudioFileNameLabel.text = performance.originalAudioFileName
      originalMidiFileNameLabel.text = performance.originalMidiFileName
      
      do {
        let url = performance.audioFileURL()
        print("audio file url: \(url)")
        audioPlayer = try AVAudioPlayer(contentsOfURL:url)
        if let audioPlayer = audioPlayer {
          audioPlayer.prepareToPlay()
        }
        print("audioPlayer \(audioPlayer)")
      } catch {
        let error = error as NSError
        print("couldn't instantiate audio player: \(error): \(error.userInfo)")
      }
      midiPlayer = MIDIFilePlayer(fileURL:performance.midiFileURL(), MIDIDevice:midiDestinationStore.destinationIndex)
    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    if let midiPlayer = midiPlayer {
      midiPlayer.clean()
    }
    
    audioPlayer = nil
    midiPlayer = nil
  }

  override func tableView(tableView:UITableView, willSelectRowAtIndexPath indexPath:NSIndexPath) -> NSIndexPath {
    print("section: \(indexPath.section)")
    print("row: \(indexPath.row)")
    
    if (indexPath.section == 0) {
      selectingAudioTrack = true
      selectingMidiTrack = false
    }
    
    if (indexPath.section == 1) {
      selectingAudioTrack = false
      selectingMidiTrack = true
    }
    
    return indexPath
  }
  
  override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?) {
    let controller = segue.destinationViewController as! FileListViewController
    controller.showAudioFiles = selectingAudioTrack
    controller.showMidiFiles = selectingMidiTrack
    controller.performance = performance
  }
  
  @IBAction func playingToggleTapped(sender: AnyObject) {
    print("playingToggleTapped")
    if let audioPlayer = audioPlayer, midiPlayer = midiPlayer {
      if (audioPlayer.playing) {
        print("audioPlayer is playing, stopping")
        audioPlayer.stop()
        midiPlayer.stop()
        playToggleButton.titleLabel!.text = "Play"
      } else {
        print("audioPlayer is stopped, playing")
        audioPlayer.play()
        midiPlayer.play()
        playToggleButton.titleLabel!.text = "Stop"
      }
    } else {
      print("something was falsey")
    }
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    if let performance = performance {
      performanceStore.update(performance)
    }
  }
  
  @IBAction func nameFieldEditingChanged(sender: AnyObject) {
    if let performance = performance, text = nameField.text {
      performance.name = text
      navigationItem.title = performance.name
    }
  }
  @IBAction func nameFieldDone(sender: AnyObject) {
    nameField.resignFirstResponder()
  }
}