//
//  LamyModelController.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LamyStylusManager.h"

/**
 * This protocol allows you to customize the appearance of a view controller created by the LamySDK
 */
@protocol LamyModelController <NSObject>

/**
 * Set to YES to have the SDK show an alert if the user tries to connect 
 * a stylus but Bluetooth is not on. Set to NO to suppress the alert.
 * Defaults to YES.
 */
@property (nonatomic) BOOL showBluetoothAlert;

/**
 * Set to YES to show instructional text alongside the Press to Connect
 * target, NO to hide it. Defaults to YES.
 */
@property (nonatomic) BOOL showPressToConnectInstructionalText;

/**
 * The stylus manager that this view controller should communicate with
 * Default to [LamyStylusManager sharedInstance].
 */
@property (nonatomic) LamyStylusManager *stylusManager;

#pragma mark - Main customization options
/**
 * A bolder color often used as a highlight color
 */
@property (nonatomic) UIColor *primaryColor;

/**
 * A softer color often used as a background color
 */
@property (nonatomic) UIColor *secondaryColor;

#pragma mark - Secondary customization options

/**
 * The color of the pen icon within the PressToConnectTarget. If not set it will default to the primary or secondary color appropriately. (Setting this is useful if you are using a custom LamyPressToConnectViewController and want the background color to be clear without losing the inner icon.) It is not possible to set this to a clear color.
 */
@property (nonatomic) UIColor *innerPressToConnectIconColor;

/**
 * A color used for table view cell backgrounds
 */
@property (nonatomic) UIColor *tableViewCellBackgroundColor;

/**
 * A color used to highlight selected cells in a table view
 */
@property (nonatomic) UIColor *selectedTableViewCellColor;

/**
 * A color used to tint the on state of a UISwitch. iOS Default if not set.
 */
@property (nonatomic) UIColor *switchOnStateColor;

/**
 * A color used for tableview seperators and other elements that should stand out on secondary colors
 */
@property (nonatomic) UIColor *separatorColor;

/**
 * Used primarily on text labels within table view cells
 */
@property (nonatomic) UIColor *textColor;

/**
 * Used primarily on detail text labels within table view cells
 */
@property (nonatomic) UIColor *detailTextColor;

/**
 * A color used primarily for table view headers
 */
@property (nonatomic) UIColor *headerTextColor;

/**
 * The font face to use on alongside the Press To Connect target.
 * Defaults to Helvetica Neue Regular.
 */
@property (nonatomic) UIFont *pressToConnectFont;

#pragma mark - Misc.
/**
 * Copies all the properties in this protocol from a given view controller to this one
 *
 * @param lamyViewController The source view controller
 */
- (void)copyModelElementsFromController:(id<LamyModelController>)lamyViewController;

/**
 * Called whenever you change an appearance related setting or the controller's view loads
 */
- (void)updateViewWithAppearanceSettings;

@end
