//
//  MIDIFilePlayer.h
//  MacRoadie
//
//  Created by Bradley Spaulding on 8/2/15.
//  Copyright (c) 2015 Motingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioToolbox/MusicPlayer.h"
#import <CoreMIDI/CoreMIDI.h>

@interface MIDIFilePlayer : NSObject {
  AUGraph graph;
  MusicPlayer player;
  MusicSequence sequence;
  MIDIEndpointRef destination;
  NSInteger deviceIndex;
}

- (id)initWithFileURL:(NSURL *)midiFileUrl MIDIDevice:(NSInteger)outputDeviceIndex;
- (void)play;
- (void)stop;
- (void)clean;
- (void)setMIDIDeviceIndex:(NSInteger)deviceIndex;

@end
