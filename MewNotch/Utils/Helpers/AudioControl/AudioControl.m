/**
 * @file AudioControl.m
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

#include "AudioControl.h"
#include <CoreAudio/CoreAudio.h>
#include <AudioToolbox/AudioServices.h>

NSString *AudioControlNotification = @"AudioControl";
NSString *AudioControlPropertyKey = @"AudioControlProperty";

@interface AudioControl ()
- (void)systemObjectPropertyDidChange;
- (void)audioDevicePropertyDidChange:(NSString *)property;
@end

static OSStatus SystemObjectPropertyListener(
    AudioObjectID device,
    UInt32 count, const AudioObjectPropertyAddress* addresses,
    void *data)
{
    [(__bridge id)data
        performSelectorOnMainThread:@selector(systemObjectPropertyDidChange)
        withObject:nil
        waitUntilDone:NO];
    
    return kAudioHardwareNoError;
}

static OSStatus AudioDeviceMuteListener(
    AudioObjectID device,
    UInt32 count, const AudioObjectPropertyAddress* addresses,
    void *data)
{
    [(__bridge AudioControl *)data
        performSelectorOnMainThread:@selector(audioDevicePropertyDidChange:)
        withObject:@"mute"
        waitUntilDone:NO];
    return kAudioHardwareNoError;
}

static OSStatus AudioDeviceVolumeListener(
    AudioObjectID device,
    UInt32 count, const AudioObjectPropertyAddress* addresses,
    void *data)
{
    [(__bridge AudioControl *)data
        performSelectorOnMainThread:@selector(audioDevicePropertyDidChange:)
        withObject:@"volume"
        waitUntilDone:NO];
    return kAudioHardwareNoError;
}

@implementation AudioControl
{
    AudioObjectPropertySelector _selector;
    AudioObjectPropertyScope _scope;
    AudioDeviceID _audiodev;
}

+ (AudioControl *)sharedInstanceOutput
{
    static AudioControl *instance = 0;
    if (0 == instance)
        instance = [[AudioControl alloc] init:TRUE];
    return instance;
}

+ (AudioControl *)sharedInstanceInput
{
    static AudioControl *instance = 0;
    if (0 == instance)
        instance = [[AudioControl alloc] init:FALSE];
    return instance;
}

- (id)init:(BOOL) output
{
    self = [super init];
    if (nil == self)
        return nil;

    _audiodev = kAudioObjectUnknown;
    _selector = output ? kAudioHardwarePropertyDefaultOutputDevice : kAudioHardwarePropertyDefaultInputDevice;
    _scope = output ? kAudioDevicePropertyScopeOutput : kAudioDevicePropertyScopeInput;

    [self registerSystemObjectListener:YES];
    [self getAudioDevice:YES];

    return self;
}

- (void)dealloc
{
    [self resetAudioDevice];
    [self registerSystemObjectListener:NO];
}

- (double)volume
{
    AudioObjectPropertyAddress address =
    {
        .mSelector = kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
        .mScope = _scope,
        .mElement = kAudioObjectPropertyElementMain,
    };
    __block Float32 volume = NAN;
    OSStatus status;

    status = [self _retry:^OSStatus(AudioDeviceID audiodev)
    {
        UInt32 size = sizeof volume;
        return AudioObjectGetPropertyData(audiodev, &address, 0, 0, &size, &volume);
    }];
    if (kAudioHardwareNoError != status)
    {
        return NAN;
    }

    return volume;
}

- (void)setVolume:(double)value
{
    AudioObjectPropertyAddress address =
    {
        .mSelector = kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
        .mScope = _scope,
        .mElement = kAudioObjectPropertyElementMain,
    };
    Float32 volume = value;
    OSStatus status;

    status = [self _retry:^OSStatus(AudioDeviceID audiodev)
    {
        return AudioObjectSetPropertyData(audiodev, &address, 0, 0, sizeof volume, &volume);
    }];
}

- (BOOL)isMute
{
    AudioObjectPropertyAddress address =
    {
        .mSelector = kAudioDevicePropertyMute,
        .mScope = _scope,
        .mElement = kAudioObjectPropertyElementMain,
    };
    __block UInt32 mute = 0;
    OSStatus status;

    status = [self _retry:^OSStatus(AudioDeviceID audiodev)
    {
        UInt32 size = sizeof mute;
        return AudioObjectGetPropertyData(audiodev, &address, 0, 0, &size, &mute);
    }];
    if (kAudioHardwareNoError != status)
    {
        return FALSE;
    }

    return !!mute;
}

- (void)setMute:(BOOL)value
{
    AudioObjectPropertyAddress address =
    {
        .mSelector = kAudioDevicePropertyMute,
        .mScope = _scope,
        .mElement = kAudioObjectPropertyElementMain,
    };
    UInt32 mute = !!value;
    OSStatus status;

    status = [self _retry:^OSStatus(AudioDeviceID audiodev)
    {
        return AudioObjectSetPropertyData(audiodev, &address, 0, 0, sizeof mute, &mute);
    }];
}

- (OSStatus)_retry:(OSStatus (^)(AudioDeviceID audiodev))block
{
    OSStatus status = kAudioHardwareNoError;

    for (NSUInteger i = 0; 2 > i; i++)
    {
        status = block([self getAudioDevice:0 != i]);
        if (kAudioHardwareBadObjectError != status)
            break;
    }

    return status;
}

- (AudioDeviceID)getAudioDevice:(BOOL)init
{
    if (kAudioObjectUnknown == _audiodev || init)
    {
        AudioObjectPropertyAddress address =
        {
            .mSelector = _selector,
            .mScope = kAudioObjectPropertyScopeGlobal,
            .mElement = kAudioObjectPropertyElementMain,
        };
        AudioDeviceID device = kAudioObjectUnknown;
        UInt32 size = sizeof device;
        OSStatus status;

        status = AudioObjectGetPropertyData(kAudioObjectSystemObject, &address, 0, 0, &size, &device);
        if (kAudioHardwareNoError == status)
        {
            _audiodev = device;

            AudioObjectPropertyAddress muteAddress =
            {
                .mSelector = kAudioDevicePropertyMute,
                .mScope = _scope,
                .mElement = kAudioObjectPropertyElementMain,
            };

            status = AudioObjectAddPropertyListener(device, &muteAddress, AudioDeviceMuteListener, (__bridge void * _Nullable)(self));
            if (status != kAudioHardwareNoError) {
                NSLog(@"Failed to add mute listener: %d", (int)status);
            }

            AudioObjectPropertyAddress volumeAddress =
            {
                .mSelector = kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
                .mScope = _scope,
                .mElement = kAudioObjectPropertyElementMain,
            };

            status = AudioObjectAddPropertyListener(device, &volumeAddress, AudioDeviceVolumeListener, (__bridge void * _Nullable)(self));
            if (status != kAudioHardwareNoError) {
                NSLog(@"Failed to add volume listener: %d", (int)status);
            }
        }
    }

    return _audiodev;
}

- (void)resetAudioDevice
{
    if (kAudioObjectUnknown != _audiodev)
    {
        AudioObjectPropertyAddress muteAddress =
        {
            .mSelector = kAudioDevicePropertyMute,
            .mScope = _scope,
            .mElement = kAudioObjectPropertyElementMain,
        };
        OSStatus status;

        status = AudioObjectRemovePropertyListener(_audiodev, &muteAddress, AudioDeviceMuteListener, (__bridge void * _Nullable)(self));

        AudioObjectPropertyAddress volumeAddress =
        {
            .mSelector = kAudioHardwareServiceDeviceProperty_VirtualMainVolume,
            .mScope = _scope,
            .mElement = kAudioObjectPropertyElementMain,
        };
        
        status = AudioObjectRemovePropertyListener(_audiodev, &volumeAddress, AudioDeviceVolumeListener, (__bridge void * _Nullable)(self));
    }
}

- (void)registerSystemObjectListener:(BOOL)add
{
    AudioObjectPropertyAddress address =
    {
        .mSelector = _selector,
        .mScope = kAudioObjectPropertyScopeGlobal,
        .mElement = kAudioObjectPropertyElementMain,
    };
    OSStatus status;

    if (add) {
        status = AudioObjectAddPropertyListener(
            kAudioObjectSystemObject,
            &address,
            SystemObjectPropertyListener,
            (__bridge void *)(self)
        );
    } else {
        status = AudioObjectRemovePropertyListener(
           kAudioObjectSystemObject,
           &address,
           SystemObjectPropertyListener,
           (__bridge void *)(self)
       );
    }
}

- (void)systemObjectPropertyDidChange
{
    [self resetAudioDevice];
    [self getAudioDevice:YES];
}

- (void)audioDevicePropertyDidChange:(NSString *)property
{
    [[NSNotificationCenter defaultCenter]
        postNotificationName:AudioControlNotification
        object:self
        userInfo:property ? @{AudioControlPropertyKey: property} : nil];
}
@end
