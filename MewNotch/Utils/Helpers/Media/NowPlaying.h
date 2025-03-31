/**
 * @file NowPlaying.h
 *
 * @copyright 2018-2019 Bill Zissimopoulos
 */
/*
 * This file is part of EnergyBar.
 *
 * You can redistribute it and/or modify it under the terms of the GNU
 * General Public License version 3 as published by the Free Software
 * Foundation.
 */

#import <Cocoa/Cocoa.h>

@interface NowPlaying : NSObject
+ (NowPlaying *)sharedInstance;
@property (retain) NSString *appBundleIdentifier;
@property (retain) NSString *appName;
@property (retain) NSImage *appIcon;

@property (retain) NSImage *albumArt;

@property (retain) NSString *album;
@property (retain) NSString *artist;
@property (retain) NSString *title;

@property (retain) NSNumber *totalDuration;
@property (retain) NSNumber *elapsedTime;

@property (retain) NSNumber *playbackRate;
@property (retain) NSDate *refreshedAt;

@property (assign) BOOL playing;

- (void)updateInfo;
@end

extern NSString *NowPlayingInfoNotification;
extern NSString *NowPlayingStateNotification;
