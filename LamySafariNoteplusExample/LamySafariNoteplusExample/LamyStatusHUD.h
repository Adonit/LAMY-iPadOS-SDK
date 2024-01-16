//
//  LamyStatusHUD.h
//  LamySafariNoteplusSwiftExample
//
//  Copyright (c) 2013 Adonit, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LamyStatusHUD : UIView

@property BOOL monoChromeAlert;
@property BOOL textOnly;

@property CGFloat displayDuration; // in Seconds. Default is 2

+ (void)showLamyHUDInView:(UIView *)viewToDisplayIn isConnected:(BOOL)isConnected modelName:(NSString *)modelName;
+ (void)showLamyHUDInView:(UIView *)viewToDisplayIn topLineMessage:(NSString *)topLineMessage bottomeLineMessage:(NSString *)bottomLineMessage;

@end
