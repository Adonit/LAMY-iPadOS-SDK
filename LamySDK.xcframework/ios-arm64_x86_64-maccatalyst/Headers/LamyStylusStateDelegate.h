//
//  LamyStylusStateDelegate.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LamyStylus;

/** The LamyStylusStateDelegate is notified of important events as the user
 * interacts with the stylus
 */
@protocol LamyStylusStateDelegate <NSObject>

/** Called when the stylus has been pressed
 */
- (void)lamyStylusPressedWithTimestamp:(NSTimeInterval)timestamp;

/** Called when the stylus has been released after a press
 */
- (void)lamyStylusReleasedWithTimestamp:(NSTimeInterval)timestamp;

/** Called when button 1 is pressed on the stylus
 */
- (void)lamyStylusButton1Pressed;

/** Called when button 1 is released on the stylus
 */
- (void)lamyStylusButton1Released;

/** Called when button 2 is pressed on the stylus
 */
- (void)lamyStylusButton2Pressed;

/** Called when button 2 is released on the stylus
 */
- (void)lamyStylusButton2Released;

/** Called when the pressure of the stylus changes
 * @param pressure The updated pressure value
 */
- (void)lamyStylusPressureUpdate:(NSUInteger)pressure;

/** Called when the battery level of the stylus changes
 * @param stylus The stylus that this battery level pertains to
 * @param battery The new battery level
 */
- (void)lamyStylus:(LamyStylus*)stylus batteryLevelUpdate:(NSUInteger)battery;

@end
