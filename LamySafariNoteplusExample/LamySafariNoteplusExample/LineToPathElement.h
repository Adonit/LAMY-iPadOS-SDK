//
//  LineToPathElement.h
//  LamySafariNoteplusSwiftExample
//
//  Copyright (c) 2012 Adonit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractBezierPathElement.h"

@interface LineToPathElement : AbstractBezierPathElement{
    CGPoint lineTo;
    
    CGPoint leftEndpoint;
    CGPoint rightEndpoint;
}

@property (nonatomic, readonly) CGPoint lineTo;

+(id) elementWithStart:(CGPoint)start andLineTo:(CGPoint)point;

@end
