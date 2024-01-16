//
//  UIColor+LamySDK.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * The default set of colors used by the Settings and Connection UI
 */
@interface UIColor (LamySDK)

/**
 * The default primary color
 */
+ (UIColor *)lamyPrimaryColor;

/**
 * The default secondary color
 */
+ (UIColor *)lamySecondaryColor;

/**
 * The default table view cell background color
 */
+ (UIColor *)lamyTableViewCellBackgroundColor;

/**
 * The default table view cell selected background color
 */
+ (UIColor *)lamySelectedTableViewCellColor;

/**
 * The default separator color
 */
+ (UIColor *)lamySeparatorColor;

/**
 * The default primary text color
 */
+ (UIColor *)lamyTextColor;

/**
 * The detail text color
 */
+ (UIColor *)lamyDetailTextColor;

/**
 * The header text color
 */
+ (UIColor *)lamyHeaderTextColor;



@end
