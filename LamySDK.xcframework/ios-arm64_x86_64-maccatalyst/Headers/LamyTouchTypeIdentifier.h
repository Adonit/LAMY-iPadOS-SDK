//
//  LamyTouchTypeIdentifier.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import "UITouch+LamyIdentification.h"

@interface LamyTouchTypeIdentifier : NSObject

/**
 * We will classify events with a type of UITouch to determine if they belong to an Lamy device. Ideally you would send us the event for processing before your applications main sendEvent so that we can identify Lamy devices prior to your views & gestures receiving touches generated by them.
 */
- (void)classifyAdonitDeviceIdentificationForEvent:(UIEvent *)event;

@end
