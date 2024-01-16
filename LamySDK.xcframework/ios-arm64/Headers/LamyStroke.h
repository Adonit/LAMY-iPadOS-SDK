//
//  LamyStroke.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A pressure and timestamped stroke created by a Lamy Stylus.
 */
@interface LamyStroke : NSObject

/**
 * Returns point location in input view.
 *
 * @param view The view from which the stroke occurs
 * @return The point of the lamyStroke within the input view
 */
- (CGPoint)locationInView:(UIView *)view;

/** Returns previous point location in input view.
 *
 * @param view The view from which the lamyStroke occurs
 * @return The point of the previous lamyStroke within the input view
 */
- (CGPoint)previousLocationInView:(UIView *)view;

/*! The value of the property is the view object in which the lamyStroke originally occurred. This object might not be the view the lamyStroke is currently in.
 */
@property (nonatomic, readonly) UIView *view;

/*! The time at which the lamyStroke occurred.
 */
@property (nonatomic, readonly) NSTimeInterval timestamp;

/*! The number of times the Stylus was tapped for this given lamyStroke.
*/
@property (nonatomic, readonly) NSUInteger tapCount;

/*! A float between 0 and 1 indicating the pressure associated with the lamyStroke, calculated from the raw pressure.
 */
@property (nonatomic, readonly) CGFloat pressure;

/*! The raw pressure associated with the lamyStroke.
 */
@property (nonatomic, readonly) NSUInteger rawPressure;

/*! A value of 0 radians indicates that the stylus is parallel to the surface; when the stylus is perpendicular to the surface, altitudeAngle is Pi/2.
    Styluses that do not support altitude angle will return a value of Pi/4.
 */
@property (nonatomic) CGFloat altitudeAngle;

/*! An array of coalescedLamyStrokes similar to the concept of coalesced UITouches. If you do not enable coalescedLamyStrokes, this will return an array populated by this lamyStroke instead. To enable coalescedLamyStrokes turn on "coalescedLamyStrokesEnabled" on an instance of LamyStylusManager. Note: Coalesced strokes are snapshots, and each instance is a separate object. For tracking a persistent stroke across events, use the non-coalesced parent lamyStroke instead of strokes from this array.
 */
@property (nonatomic, readonly) NSArray<LamyStroke*> *coalescedLamyStrokes;

/*! An array of auxiliary LamyStrokes for stroke events that are predicted to occur for a given main LamyStroke. These predictions may not exactly match the real behavior of the stroke as the stylus moves, so they should be interpreted as an estimate. To enable predictedLamyStrokes turn on "predictedLamyStrokesEnabled" on an instance of LamyStylusManager.
  */
@property (nonatomic, readonly) NSArray<LamyStroke*> *predictedLamyStrokes;

/*! A value of 0 radians points along the positive x axis; when the stylus tip is pointing towards the bottom of the view, azimuthAngle is Pi/2.
 Styluses that do not support azimuth angle will return a value of Pi/4.
 *
 * @param view The view that contains the stylus’s touch. Pass nil to get the azimuth angle that is relative to the touch’s window
 * @return The azimuth angle of the stylus, in radians.
 */
- (CGFloat)azimuthAngleInView:(UIView *)view;

/*! Returns a unit vector that points in the direction of the azimuth of the stylus.
 *
 * @param view The view that contains the stylus’s touch. Pass nil to get the unit vector for the azimuth that is relative to the touch’s window.
 * @return The unit vector that points in the direction of the azimuth of the stylus.
 */
- (CGVector)azimuthUnitVectorInView:(UIView *)view;


@end
