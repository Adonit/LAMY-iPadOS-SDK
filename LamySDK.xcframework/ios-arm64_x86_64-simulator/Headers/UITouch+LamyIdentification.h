//
//  UITouch+LamyStylus.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 * Identifies the source of a touch
 */
typedef NS_ENUM(NSUInteger, LamyTouchIdentificationType) {
    LamyTouchIdentificationTypeUnknown,
    LamyTouchIdentificationTypeNotDevice,
    LamyTouchIdentificationTypePotentialDevice,
    LamyTouchIdentificationTypeStylus,
    LamyTouchIdentificationTypeDebugPlaceholder
};

/**
 * Provides additional information about the source of each UITouch
 */
@interface UITouch (LamyIdentification)

/**
 * Identifies whether or not the SDK thinks this UITouch is being generated by an Lamy Device
 */
@property (assign, nonatomic) LamyTouchIdentificationType lamyTouchIdentification;

@end
