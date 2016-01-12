class Performance {
  var id : AnyObject?
  var name : String
  var originalMidiFileName : String
  var originalAudioFileName : String
  
  init() {
    self.id = nil
    self.name = "Untitled Performance"
    self.originalMidiFileName = ""
    self.originalAudioFileName = ""
  }
  
  init(id:AnyObject?, name:String, originalMidiFileName:String, originalAudioFileName:String) {
    self.id = id
    self.name = name
    self.originalMidiFileName = originalMidiFileName
    self.originalAudioFileName = originalAudioFileName
  }
  
  func audioFileURL() -> NSURL {
    return singletons.sharedFilesStore.urlForFile(originalAudioFileName)
  }
  
  func midiFileURL() -> NSURL {
    return singletons.sharedFilesStore.urlForFile(originalMidiFileName)
  }
}