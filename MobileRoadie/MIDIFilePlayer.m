#import "MIDIFilePlayer.h"
#import "MIDIDeviceScanner.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation MIDIFilePlayer

- (id)initWithFileURL:(NSURL *)midiFileUrl MIDIDevice:(NSInteger)outputDeviceIndex {
  self = [super init];
  if (self) {
    deviceIndex = outputDeviceIndex;
    [self createAUGraph];
    [MIDIDeviceScanner logMIDIDestinations];
    [self initMIDIFile: midiFileUrl];
  }
  return self;
}

- (void)initMIDIFile:(NSURL *)fileUrl {
  NewMusicSequence(&sequence);
  MusicSequenceFileLoad(sequence, (__bridge CFURLRef)fileUrl, 0, 0);

  //CAShow(sequence);
  
  destination = MIDIGetDestination(deviceIndex);
  MusicSequenceSetMIDIEndpoint(sequence, destination);
  
  NewMusicPlayer(&player);
  
  MusicSequenceSetAUGraph(sequence, graph);
  
  MusicPlayerSetSequence(player, sequence);
  
  MusicPlayerPreroll(player);
}

- (void)play {
  MusicPlayerStart(player);
}

- (void)stop {
  MusicPlayerStop(player);
}

- (void)clean {
  DisposeMusicSequence(sequence);
  DisposeMusicPlayer(player);
}

- (AUGraph)createAUGraph {
  OSStatus result = noErr;
  
  AUNode ioNode;
  
  AudioComponentDescription description = {};
  description.componentManufacturer = kAudioUnitManufacturer_Apple;
  
  result = NewAUGraph(&graph);
  NSCAssert(result == noErr, @"Unable to create an AUGraph object. Error code: %d '%.4s'", (int) result, (const char *)&result);
  
  description.componentType = kAudioUnitType_Output;
  description.componentSubType = kAudioUnitSubType_RemoteIO; // iOS
  //description.componentSubType = kAudioUnitSubType_DefaultOutput; // Mac
  
  result = AUGraphAddNode(graph, &description, &ioNode);
  NSCAssert (result == noErr, @"Unable to add the Output unit to the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
  
  result = AUGraphOpen(graph);
  NSCAssert (result == noErr, @"Unable to open the audio processing graph. Error code: %d '%.4s'", (int) result, (const char *)&result);
  
  return graph;
}

- (void)setMIDIDeviceIndex:(NSInteger)newDeviceIndex {
  deviceIndex = newDeviceIndex;
  destination = MIDIGetDestination(deviceIndex);
  MusicSequenceSetMIDIEndpoint(sequence, destination);
}

@end
