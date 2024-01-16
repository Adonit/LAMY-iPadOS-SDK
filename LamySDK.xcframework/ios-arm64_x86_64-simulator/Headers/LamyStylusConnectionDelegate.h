//
//  LamyStylusConnectionDelegate.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class LamyStylus;
@protocol LamyStylusConnection;

/** The LamyStylusConnectionDelegate is notified of important events as styluses
 * connect and disconnect from the applicaiton
 */
@protocol LamyStylusConnectionDelegate <NSObject>

/**
 * Sent to update the status of stylus to discovered
 * @param stylus The stylus that was discovered
 */
- (void)lamyStylusDiscovered:(LamyStylus *)stylus;

/** Sent to update the status of stylus to pairing
 * @param stylus The stylus that is pairing
 */
- (void)lamyStylusPairing:(LamyStylus *)stylus;

/** Sent to update the status of stylus to connected
 * @param stylus The stylus that is connected
 */
- (void)lamyStylusConnected:(LamyStylus *)stylus;

/** Sent to update the status of stylus to disconnected
 * @param stylus The stylus that is disconnected
 */
- (void)lamyStylusDisconnected:(LamyStylus *)stylus;

/** Sent when the device does not support bluetooth 4
 */
- (void)lamyStylusUnsupported;

/** Sent when the device does not support stylus
 */
- (void)lamyStylusPlatformNotSupported;

/** Sent when the device does not support stylus by swap stylus
 */
- (void)lamyStylusPlatformNotSupportedBySwap;

/**
 * Sent when a discovery attempt is cancelled
 */
- (void)lamyStylusDiscoveryCancelled;

/** Sent when the device bluetooth on
 * @param stylus The stylus that is power on
 */
- (void)lamyStylusBluetoothOn;

/** Sent when the device bluetooth off
 * @param stylus The stylus that is power off
 */
- (void)lamyStylusBluetoothOff;

@optional

/** Sent when a stylus is about to be disconnected
 * @param stylus The stylus that will be disconnected
 */
- (void)lamyStylusWillDisconnect:(LamyStylus *)stylus;

@end

