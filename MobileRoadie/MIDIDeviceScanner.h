#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

@interface MIDIDeviceScanner : NSObject
+ (void)logMIDIDestinations;
+ (NSArray *)getMIDIDestinations;
+ (NSString *)getMIDIDestinationNameForIndex:(NSInteger)index;
@end
