//
//  LamyConstants.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSUInteger const LAMY_STYLUS_MIN_PRESSURE;
extern NSUInteger const LAMY_STYLUS_MAX_PRESSURE;

extern NSString * const LamyStylusManagerDidChangeConnectionStatus;
extern NSString * const LamyStylusManagerDidUpdateConnectionStatus;
extern NSString * const LamyStylusManagerDidChangeConnectionStatusStatusKey;

extern NSString * const LamyStylusManagerDidChangeEnabledStatus;
extern NSString * const LamyStylusManagerDidChangeEnabledStatusStatusKey;

extern NSString * const LamyStylusManagerDidChangeBatteryLevel;

extern NSString * const LamyStylusManagerDidChangeStylusFriendlyName;
extern NSString * const LamyStylusManagerDidChangeStylusFriendlyNameNameKey;

extern NSString * const LamyStylusTrackingPressureForConnectionNotification;
extern NSString * const LamyStylusTrackingPressureForConnectionFailedNotification;
extern NSString * const LamyStylusTrackingPressureForConnectionSuccessfulNotification;

extern NSString * const LamyStylusNotificationRecommend;
extern NSString * const LamyStylusNotificationRecommendKey;

// Notification sent when the battery changes state to normal. Normal is 20-100%
extern NSString * const LamyStylusNotificationBatteryLevelNormal;

// Notification sent when the battery changes state to low. Low is 10-20%
extern NSString * const LamyStylusNotificationBatteryLevelLow;

// Notification sent when the battery changes state to critical. Critical is 0-10%
extern NSString * const LamyStylusNotificationBatteryLevelCritical;

// Notification sent when the user presses button 1 down
extern NSString * const LamyStylusButton1Down;

// Notification sent when the user releases button 1
extern NSString * const LamyStylusButton1Up;

// Notification sent when the user presses button 2 down
extern NSString * const LamyStylusButton2Down;

// Notification sent when the user releases button 2
extern NSString * const LamyStylusButton2Up;

// Notification sent when the user presses button 3 down
extern NSString * const LamyStylusButton3Down;

// Notification sent when the user releases button 3
extern NSString * const LamyStylusButton3Up;

// Notification sent when the user presses button 4 down
extern NSString * const LamyStylusButton4Down;

// Notification sent when the user releases button 4
extern NSString * const LamyStylusButton4Up;

extern NSString * const LamyStylusButton1DoubleTap;
extern NSString * const LamyStylusButton2DoubleTap;
extern NSString * const LamyStylusScrollRelativeValueUpdated;
extern NSString * const LamyStylusScrollValue;

/**
 * Describes how the user typically holds their Lamy Stylus
 */
typedef NS_ENUM(NSUInteger, LamyWritingStyle) {
    /** The user is right-handed and holds the stylus perpendicular to their wrist */
    LamyWritingStyleRightHorizontal = 2,
    /** The user is right-handed and holds the stylus at a 45 degree angle to their wrist */
    LamyWritingStyleRightAverage = 1,
    /** The user is right-handed and holds the stylus parallel to their wrist */
    LamyWritingStyleRightVertical = 0,
    /** The user is left-handed and holds the stylus perpendicular to their wrist */
    LamyWritingStyleLeftHorizontal = 5,
    /** The user is left-handed and holds the stylus at a 45 degree angle to their wrist */
    LamyWritingStyleLeftAverage = 4,
    /** The user is left-handed and holds the stylus parallel to their wrist */
    LamyWritingStyleLeftVertical = 3,
};

/**
 * The connection state of the Lamy Stylus
 */
typedef NS_ENUM(NSUInteger, LamyConnectionStatus) {
    /** The last stylus has been turned off and forgotten */
        LamyConnectionStatusOff,
    /** The SDK is scanning for Lamy Stylus to connect to */
        LamyConnectionStatusScanning,
    /** The SDK is connecting to a particular Lamy Stylus */
        LamyConnectionStatusPairing,
    /** A Lamy stylus  is currently connected */
        LamyConnectionStatusConnected,
    /** No Lamy stylus is connected, but the most recently used Lamy stylus will be automatically connected to when available */
        LamyConnectionStatusDisconnected,
    /** A Lamy stylus is power off */
        LamyConnectionStatusPowerOff,
    /** A Lamy stylus is not support for this platform */
        LamyConnectionStatusStylusNotSupportThePlatform,
    /** A Lamy stylus is not support for this platform by swap stylus*/
        LamyConnectionStatusSwapStylusNotSupportThePlatform
};

/** The maximum length for a friendly name */
extern NSUInteger const LamyStylusStorageFriendlyNameMaxLength;

/** The maximum length for an owner link */
extern NSUInteger const LamyStylusStorageOwnerLinkMaxLength;

/** The maximum length for preference data */
extern NSUInteger const LamyStylusStoragePreferenceDataMaxLength;

/** The maximum length for a URL string */
extern NSUInteger const LamyStylusStorageURLStringMaxLength;

/**
 * The error domain for the LamySDK
 */
extern NSString * const LamySDKErrorDomain;

/** 
 * Custom error codes for the Lamy SDK
 */
typedef NS_ENUM(NSInteger, LamySDKErrorType) {
    /** A generic error code */
        LamySDKErrorTypeUnknown = 0,
    /** Used when a discovery attempt is requested, but the SDK is disabled */
        LamySDKErrorTypeSDKNotEnabled = 99,
    /** Used when a stylus operation is requested, but no stylus is currently connected */
        LamySDKErrorTypeNoMainStylusAssigned = 100,
    /** Used when a stylus operation is requested that is not supported by the currently connected stylus */
        LamySDKErrorTypeFunctionalityNotSupportedOnDevice = 101,
    /** Used when a stylus operation fails to complete in time */
        LamySDKErrorTypeTimeout = 102,
    /** Used when the stylus fails to reset to factory defaults */
        LamySDKErrorTypeResetFailure = 103,
    /** Used when an operation is requested while no stylus is connected */
        LamySDKErrorTypeStylusNotConnected = 104,
    /** Used when stylus try to connect with unsupported iPad */
        LamySDKErrorTypeStylusNotSupportedOnTablet = 105,
    /** Used when an invalid storage index is requested */
        LamySDKErrorTypeStorageIndexOutOfBounds = 301,
    /** Used when an invalid storage location is requested */
        LamySDKErrorTypeStorageRangeOutOfBounds = 302,
    /** Used when the storage range is not equal to the length of the data to write */
        LamySDKErrorTypeStorageWriteDataInconsistentWithTargetRange = 303,
    /** Used when an unknown read error occurs on the stylus */
        LamySDKErrorTypeStorageReadUnknown = 304,
    /** Used when an invalid write command is sent to the stylus */
        LamySDKErrorTypeStorageWriteInvalidCommand = 305,
    /** Used when the checksum on a write command fails */
        LamySDKErrorTypeStorageWriteChecksumError = 306,
    /** Used when an unknown error occurs during a write command */
        LamySDKErrorTypeStorageWriteUnknown = 307,
    /** Used when an operation is sent but the discovery process has not yet completed */
        LamySDKErrorTypeStorageNotReady = 308,
    /** Used when the friendly name to write exceeds LamyStylusStorageFriendlyNameMaxLength */
        LamySDKErrorTypeFriendlyNameTooLong = 401,
    /** Used when the URL string to write exceeds LamyStylusStorageURLStringMaxLength */
        LamySDKErrorTypeURLStringTooLong = 402,
    /** Used when the owner link to write exceeds LamyStylusStorageOwnerLinkMaxLength */
        LamySDKErrorTypeOwnerLinkTooLong = 403,
    /** Used when the preference data to write exceeds LamyStylusStoragePreferenceDataMaxLength */
        LamySDKErrorTypePreferenceDataTooLong = 404,
    /** Used when help cannot be opened because no application on the device can open it */
        LamySDKErrorTypeCannotOpenHelp = 500,
    /** Used when help cannot be opened because the device does not have an active Internet connection */
        LamySDKErrorTypeNoInternetConnectionForHelp = 501
};

/**
 * Describes how the user set the color for their stylus
 */
typedef NS_ENUM(NSUInteger, LamyStylusColorStyle) {
    /** To set the stylus color black */
    LamyStylusColorStyleBlack = 0,
    /** To set the stylus color blue */
    LamyStylusColorStyleBlue = 1,
    /** To set the stylus color eed */
    LamyStylusColorStyleRed = 2,
    /** To set the stylus color white */
    LamyStylusColorStyleWhite = 3,
};
