#import "MIDIDeviceScanner.h"

// Returns the display name of a given MIDIObjectRef as an NSString
NSString *getDisplayName(MIDIObjectRef object) {
  CFStringRef name = nil;
  if (noErr != MIDIObjectGetStringProperty(object, kMIDIPropertyDisplayName, &name))
    return @"No MIDI Device";
  return (__bridge NSString *)name;
}

@implementation MIDIDeviceScanner
+ (void)logMIDIDestinations {
  NSLog(@"Iterate through destinations");
  ItemCount destCount = MIDIGetNumberOfDestinations();
  for (ItemCount i = 0 ; i < destCount ; ++i) {
    MIDIEndpointRef dest = MIDIGetDestination(i);
    NSLog(@"  Destination: %@", getDisplayName(dest));
  }
}

+ (NSArray<NSString *> *)getMIDIDestinations {
  ItemCount destCount = MIDIGetNumberOfDestinations();
  NSMutableArray *destinations = [NSMutableArray arrayWithCapacity:destCount];
  for (ItemCount i = 0 ; i < destCount ; ++i) {
    MIDIEndpointRef dest = MIDIGetDestination(i);
    [destinations insertObject:getDisplayName(dest) atIndex:i];
  }
  return [destinations copy];
}

+ (NSString *)getMIDIDestinationNameForIndex:(NSInteger)index {
  return getDisplayName(MIDIGetDestination(index));
}
@end
