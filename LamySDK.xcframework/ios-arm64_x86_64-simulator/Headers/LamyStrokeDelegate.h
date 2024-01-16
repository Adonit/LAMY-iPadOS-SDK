//
//  LamyStrokeDelegate.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LamyStroke.h"



/** The LamyStrokeDelegate receives important events related to stylus events
 */
@protocol LamyStrokeDelegate <NSObject>

#pragma mark - Stylus Events
/** Called when the stylus begins a stroke event
 * @param lamyStroke where the stylus began its stroke
 */
- (void)lamyStylusStrokeBegan:(nonnull LamyStroke *)stylusStroke;

/** Called when the lamy stylus moves across the screen
 * @param lamyStroke where stylus is moving
 */
- (void)lamyStylusStrokeMoved:(nonnull LamyStroke *)stylusStroke;

/** Called when the lamy stylus is lifted from the screen
 * @param lamyStroke where stylus ends
 */
- (void)lamyStylusStrokeEnded:(nonnull LamyStroke *)stylusStroke;

/** Called when strokes by the lamy stylus are cancelled
 * @param lamyStroke where stylus cancels
 */
- (void)lamyStylusStrokeCancelled:(nonnull LamyStroke *)stylusStroke;

#pragma mark - Gesture Suggestions
/** Suggest to disable gestures when the pen is down to prevent conflict
 */
- (void)suggestsToDisableGestures;

/** Suggest to enable gestures when the pen is not down as there are no potential conflicts
 */
- (void)suggestsToEnableGestures;

@end

