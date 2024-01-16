//
//  LamyStylusMotionManager.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@class LamyStylus;

@interface LamyStylusAccelerometerData : NSObject
@property (readonly, nonatomic) NSTimeInterval timestamp;
@property (readonly, nonatomic) CMAcceleration acceleration;
@end

typedef void (^LamyStylusAccelerometerHandler) (LamyStylusAccelerometerData *accelerometerData, NSError *error);
typedef void (^LamyStylusShockEventHandler) (NSError *error);

extern NSString * const LamyStylusNotificationShockEvent;

@interface LamyStylusMotionManager : NSObject
@property (readonly, nonatomic, getter=isAccelerometerActive) BOOL accelerometerActive;
@property (readonly, nonatomic, getter=isAccelerometerAvailable) BOOL accelerometerAvailable;
@property (nonatomic) NSTimeInterval accelerometerUpdateInterval;
@property (readonly) LamyStylusAccelerometerData *accelerometerData;
- (void)startAccelerometerUpdatesToQueue:(NSOperationQueue *)queue withHandler:(LamyStylusAccelerometerHandler)handler;
- (void)stopAccelerometerUpdates;
@end
