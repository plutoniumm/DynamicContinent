//
//  Brightness.m
//  MewNotch
//
//  Created by Monu Kumar on 3/8/25.
//

#include "Brightness.h"
#import <Foundation/Foundation.h>

#import <IOKit/IOKitLib.h>

NSString *BrightnessNotification = @"Brightness";
NSString *BrightnessPropertyKey = @"BrightnessProperty";

int DisplayServicesRegisterForBrightnessChangeNotifications(
    CGDirectDisplayID display,
    CGDirectDisplayID displayObserver,
    CFNotificationCallback callback
);

int DisplayServicesUnregisterForBrightnessChangeNotifications(
    CGDirectDisplayID display,
    CGDirectDisplayID displayObserver
);

@interface Brightness ()
- (void)displayBrightnessDidChange;
@end

static void DisplayBrightnessListener(
    CFNotificationCenterRef center,
    void *observer,
    CFNotificationName name,
    const void *object,
    CFDictionaryRef userInfo
) {
    [Brightness.sharedInstance
        performSelectorOnMainThread:@selector(displayBrightnessDidChange)
        withObject:(__bridge id _Nullable)(object)
        waitUntilDone:NO];
    
    return;
}

@implementation Brightness
{ }

+ (Brightness *)sharedInstance
{
    static Brightness *instance = 0;
    if (0 == instance)
        instance = [[Brightness alloc] init];
    return instance;
}

- (id)init
{
    self = [super init];
    if (nil == self)
        return nil;

    [self registerListener:YES];

    return self;
}

- (void)dealloc
{
    [self registerListener:NO];
}

- (double)brightness
{
    float brightness = NAN;
    
    DisplayServicesGetBrightness(
        CGMainDisplayID(),
        &brightness
    );
    
    return brightness;
}

- (void)setBrightness:(double)value
{
    DisplayServicesSetBrightness(
        CGMainDisplayID(),
        value
    );
}

- (void)registerListener:(BOOL)add
{

    if (add) {
        DisplayServicesRegisterForBrightnessChangeNotifications(
            CGMainDisplayID(),
            CGMainDisplayID(),
            DisplayBrightnessListener
        );
    } else {
        DisplayServicesUnregisterForBrightnessChangeNotifications(
            CGMainDisplayID(),
            CGMainDisplayID()
        );
    }
}

- (void)displayBrightnessDidChange
{
    [[NSNotificationCenter defaultCenter]
        postNotificationName:BrightnessNotification
        object:self
        userInfo: nil
    ];
}
@end
