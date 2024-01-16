//
//  LamyStylusScrollValueDelegate.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LamyStylusScrollValueDelegate <NSObject>

- (void)scrollValueUpdate:(CGFloat)value;

- (void)scrollShortcutChange;

@end
