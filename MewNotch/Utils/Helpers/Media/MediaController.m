//
//  MediaController.m
//  MewNotch
//
//  Created by Monu Kumar on 26/03/25.
//

#import "MediaController.h"

typedef enum {
    kMRPlay = 0,
    kMRPause = 1,
    kMRTogglePlayPause = 2,
    kMRStop = 3,
    
    kMRNextTrack = 4,
    kMRPreviousTrack = 5,
    
    kMRToggleShuffle = 6,
    kMRToggleRepeat = 7,
    
    kMRGoBackFifteenSeconds = 12,
    kMRSkipFifteenSeconds = 13,
} MRCommand;

Boolean MRMediaRemoteSendCommand(MRCommand command, id userInfo);

@implementation MediaController
+ (MediaController *)sharedInstance
{
    static MediaController *instance = 0;
    if (0 == instance)
        instance = [[MediaController alloc] init];
    return instance;
}

- (id)init
{
    self = [super init];
    if (nil == self)
        return nil;

    return self;
}


- (void)play
{
    MRMediaRemoteSendCommand(
        kMRPlay,
        nil
    );
}

- (void)pause
{
    MRMediaRemoteSendCommand(
        kMRPause,
        nil
    );
}

- (void)togglePlayPause
{
    MRMediaRemoteSendCommand(
        kMRTogglePlayPause,
        nil
    );
}

- (void)stop
{
    MRMediaRemoteSendCommand(
        kMRStop,
        nil
    );
}


- (void)next
{
    MRMediaRemoteSendCommand(
        kMRNextTrack,
        nil
    );
}

- (void)previous
{
    MRMediaRemoteSendCommand(
        kMRPreviousTrack,
        nil
    );
}


- (void)toggleShuffle
{
    MRMediaRemoteSendCommand(
        kMRToggleShuffle,
        nil
    );
}

- (void)toggleRepeat
{
    MRMediaRemoteSendCommand(
        kMRToggleRepeat,
        nil
    );
}


- (void)seekBackFifteenSeconds
{
    MRMediaRemoteSendCommand(
        kMRGoBackFifteenSeconds,
        nil
    );
}

- (void)seekForwardFifteenSeconds
{
    MRMediaRemoteSendCommand(
        kMRSkipFifteenSeconds,
        nil
    );
}

@end

