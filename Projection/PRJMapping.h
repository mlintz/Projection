//
//  PRJMapping.h
//  Projection
//
//  Created by Mikey Lintz on 2/1/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

//   - document when rounding happens (never! mapping does rounding)
//   - document quirks in PRJMapping subscription (retains (not copy) key,
//            creates new key if one doesn't exist on a get)
//            copies on assign
//   - Apply does center and bounds

@class PRJRect;

/** A mapping class for associating UIViews with PRJRects.

PRJMapping behaves like an NSMutableDictionary with the following exceptions:

- PRJMapping retains UIView keys instead of copying them.
- PRJMapping copies PRJValues instead of retaining them.
- objectForKeyedSubscript will create and store a new PRJRect instead of returning nil if there
  isn't a value associated with a UIView. This means that clients will rarely have to create
  PRJRects on their own.

Invoking "apply" iterates through all view/rect entries and sets the rect's integralFrame as the
view's frame.

Usage:
    PRJMapping *mapping = [[PRJMapping alloc] init];
    mapping[someView].size = CGSizeMake(50, 50);  // A new PRJRect is automatically created;
    mapping[someView].topLeft = CGPointMake(10, 20.1234);
    [mapping apply];
    CGRect frame = someView.frame;  // frame = (10 20; 50 50);

*/

@interface PRJMapping : NSObject
NS_ASSUME_NONNULL_BEGIN

/** Returns the PRJRect associated with the given UIView.
@param key The UIView for which to return the associatedPRJRect.
@return The PRJRect associated with with key. If no value exists, the receiver creates, stores, and
returns a new PRJRect.
*/
- (PRJRect *)objectForKeyedSubscript:(UIView *)key;

/** Adds a given PRJRect, UIView pair to the receiver.

This method will rarely need to be invoked since objectForKeyedSubscript will automatically create
a new PRJRect if necessary.

@param obj The PRJRect for key. Instead of retaining obj, a copy of obj is created and stored
instead.
@param key The UIView key for obj. The UIView is retained.

*/
- (void)setObject:(PRJRect *)obj forKeyedSubscript:(UIView *)key;

/// Iterates through all view/rect entries and sets the rect's integralFrame as the view's frame.
- (void)apply;

NS_ASSUME_NONNULL_END
@end
