//
//  LamyRadiusView.h
//  LamySafariNoteplusSwiftExample
//
//  Created by Ian Busch on 11/30/15.
//  Copyright © 2015 Adonit, USA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LamySDK.h"

@interface LamyRadiusView : UIView
- (void)updateViewWithTouch:(UITouch *)touch;
- (void)updateViewWithLamyStroke:(LamyStroke *)stylusStroke;
@end
