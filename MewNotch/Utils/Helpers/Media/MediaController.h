//
//  MediaController.h
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

#import <Cocoa/Cocoa.h>

@interface MediaController : NSObject
+ (MediaController *)sharedInstance;

- (void)play;
- (void)pause;
- (void)togglePlayPause;
- (void)stop;

- (void)next;
- (void)previous;

- (void)toggleShuffle;
- (void)toggleRepeat;

- (void)seekBackFifteenSeconds;
- (void)seekForwardFifteenSeconds;
@end

