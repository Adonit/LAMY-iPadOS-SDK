//
//  UIStoryboard+LamySDK.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LamyModelController.h"

//A view controller that shows the connection state of a Lamy Stylus and presents
//the Connection and Settings View Controller when tapped
extern NSString * const LamyViewControllerUnifiedStatusButtonAndConnectionAndSettingsIdentifier;

//A view controller that can be used to connect and configure a Lamy Stylus
extern NSString * const LamyViewControllerUnifiedStylusConnectionAndSettingsIdentifier;

//A view controller that can be used to connect a Lamy Stylus
extern NSString * const LamyViewControllerPressToConnectIdentifier;

//A view controller that can be used to select actions for shortcut button A
extern NSString * const LamyViewControllerShortCutButtonAIdentifier;

//A view controller that can be used to select actions for shortcut button B
extern NSString * const LamyViewControllerShortCutButtonBIdentifier;

//A view controller that can be used to show the battery level of a Lamy Stylus
extern NSString * const LamyViewControllerBatteryIdentifier;

//A view controller that can be used to show the hardware status for debugging purposes
extern NSString * const LamyViewControllerDebugStatusIdentifier;

/**
 * Allows for the creation of  Lamy View Controllers which assist in the connection and configuration of Lamy stylus
 */
@interface UIStoryboard (LamySDK)

/**
 * A view controller that can be used to connect and configure a Lamy stylus. Returns the
 * controller with the LamyViewControllerUnifiedStatusButtonAndConnectionAndSettingsIdentifier
 */
+ (UIViewController<LamyModelController> *)instantiateInitialLamyViewController;
    
/**
 * Use this to gain access to view controllers that are a part of the Lamy connection and configuration process
 *
 * @param identifier A unique identifier for the view controller you wish to create
 */
+ (UIViewController<LamyModelController> *)instantiateLamyViewControllerWithIdentifier:(NSString *)identifier;

@end
