struct Singletons {
  let performanceStore = PerformanceStore()
  let sharedFilesStore = SharedFilesStore()
  let midiDestinationStore = MIDIDestinationStore()
}

let singletons = Singletons()