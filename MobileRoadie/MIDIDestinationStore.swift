class MIDIDestinationStore : Observable {
  var destinationIndex = 0 {
    didSet { emitChange() }
  }
  
  func destinationName() -> String {
    return MIDIDeviceScanner.getMIDIDestinationNameForIndex(destinationIndex)
  }
  
  func destinations() -> [String] {
    return MIDIDeviceScanner.getMIDIDestinations() as! [String]
  }
}