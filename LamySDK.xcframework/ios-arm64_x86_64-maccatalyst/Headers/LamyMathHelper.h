//
//  LamyMathHelper.h
//  LamySDK
//
//  Copyright (c) 2023 Adonit. All rights reserved.
//

#ifndef LamySDK_LamyMathHelper_h
#define LamySDK_LamyMathHelper_h

static inline int LamyCGFloatCompare (const void *a, const void *b)
{
    const CGFloat *da = (const CGFloat *) a;
    const CGFloat *db = (const CGFloat *) b;
    
    return (*da > *db) - (*da < *db);
}

static inline BOOL LamyFloatCompare(CGFloat first, CGFloat second, CGFloat threshold)
{
    CGFloat diff = fabs(first - second);
    return diff < threshold;
}

static inline CGPoint LamyGetRectCenterAbsolute(CGRect rect) {
	return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

static inline CGPoint LamyGetRectCenterLocal(CGRect rect) {
	return CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5);
}

static inline CGFloat LamyDistanceBetweenPoints(CGPoint a, CGPoint b) {
    double dx = (b.x-a.x);
    double dy = (b.y-a.y);
    double dist = sqrt(dx*dx + dy*dy);
    return dist;
}

static inline CGFloat LamyLerpFloat(CGFloat from, CGFloat to, CGFloat delta) {
	return from + (to - from) * delta;
}

static inline CGRect LamyLerpRect(CGRect from, CGRect to, CGFloat delta) {
	CGFloat x = LamyLerpFloat(from.origin.x, to.origin.x, delta);
	CGFloat y = LamyLerpFloat(from.origin.y, to.origin.y, delta);
	CGFloat w = LamyLerpFloat(from.size.width, to.size.width, delta);
	CGFloat h = LamyLerpFloat(from.size.height, to.size.height, delta);
	
	return CGRectMake(x, y, w, h);
}

static inline CGFloat LamyMapFloat(CGFloat value, CGFloat mapFromStart, CGFloat mapFromEnd, CGFloat mapToStart, CGFloat mapToEnd, BOOL clamped) {
	CGFloat from = (value - mapFromStart) / (mapFromEnd - mapFromStart);
	CGFloat to = LamyLerpFloat(mapToStart, mapToEnd, from);
	if(clamped) {
		return MIN(MAX(to, mapToStart), mapToEnd);
	} else {
		return to;
	}
}

//shorthand helper
static inline CGFloat LamyMapFloatToDelta(CGFloat value, CGFloat mapFromStart, CGFloat mapFromEnd, BOOL clamped) {
	return LamyMapFloat(value, mapFromStart, mapFromEnd, 0, 1, clamped);
}

static inline CGPoint LamyLerpPoint(CGPoint from, CGPoint to, CGFloat delta) {
	float x = LamyLerpFloat(from.x, to.x, delta);
	float y = LamyLerpFloat(from.y, to.y, delta);
	
	return CGPointMake(x, y);
}

static inline CGPoint LamyClampPointX(CGPoint point, CGFloat xMin, CGFloat xMax) {
	float x = MIN(MAX(point.x, xMin), xMax);
	return CGPointMake(x, point.y);
}

static inline CGPoint LamyClampPointY(CGPoint point, CGFloat yMin, CGFloat yMax) {
	float y = MIN(MAX(point.y, yMin), yMax);
	return CGPointMake(point.x, y);
}

static inline CGPoint LamyClampPointToRect(CGPoint point, CGRect rect) {
	float x = MIN(MAX(point.x, rect.origin.x), rect.origin.x + rect.size.width);
	float y = MIN(MAX(point.y, rect.origin.y), rect.origin.y + rect.size.height);
	
	return CGPointMake(x, y);
}

static inline CGFloat LamyQuadBezierIteration(CGFloat t, CGFloat P0, CGFloat P1, CGFloat P2) {
    return (1 - t) * (1 - t) * P0 + 2 * (1 - t) * t * P1 + t * t * P2;
}

static inline CGFloat LamyCubicBezierIteration(CGFloat t, CGFloat P0, CGFloat P1, CGFloat P2, CGFloat P3) {
    return
    (1-t)*(1-t)*(1-t) * P0
    + 3 * (1-t)*(1-t) * t * P1
    + 3 * (1-t) * t*t * P2
    + t*t*t * P3;
}

static inline CGFloat LamyDegreesToRadians( double degrees ) {
    return ( degrees ) / 180.0 * M_PI;
}

static inline CGFloat LamyRadiansToDegrees( double radians ) {
    return ( radians ) * ( 180.0 / M_PI ) + 90;
}

#endif
