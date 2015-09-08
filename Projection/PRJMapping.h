//
//  PRJMapping.h
//  Projection
//
//  Created by Mikey Lintz on 2/1/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PRJRect;

/** A mapping class for associating projectables (views and layers) with PRJRects.

PRJMapping behaves like an NSMutableDictionary with the following exceptions:

- PRJMapping retains keys instead of copying them.
- PRJMapping copies PRJValues instead of retaining them.
- objectForKeyedSubscript will create and store a new PRJRect instead of returning nil if there
  isn't a value associated with a projectable. This means that clients will rarely have to create
  PRJRects on their own.

Invoking "apply" iterates through all entries and sets the rect's integralFrame as the
projectable's frame.

Usage:
    PRJMapping *mapping = [[PRJMapping alloc] init];
    mapping[someView].size = CGSizeMake(50, 50);  // A new PRJRect is automatically created;
    mapping[someView].topLeft = CGPointMake(10, 20.1234);
    [mapping apply];
    CGRect frame = someView.frame;  // frame = (10 20; 50 50);

*/

@protocol PRJProjectable <NSObject>
NS_ASSUME_NONNULL_BEGIN

- (void)prj_apply:(PRJRect *)rect;

NS_ASSUME_NONNULL_END
@end

@interface PRJMapping : NSObject
NS_ASSUME_NONNULL_BEGIN

/** Returns the PRJRect associated with the given Projectable.
@param key The id<PRJProjectable> for which to return the associatedPRJRect.
@return The PRJRect associated with with key. If no value exists, the receiver creates, stores, and
returns a new PRJRect.
*/
- (PRJRect *)objectForKeyedSubscript:(id<PRJProjectable>)key;

/** Adds a given PRJRect, id<PRJProjectable> pair to the receiver.

This method will rarely need to be invoked since objectForKeyedSubscript will automatically create
a new PRJRect if necessary.

@param obj The PRJRect for key. Instead of retaining obj, a copy of obj is created and stored
instead.
@param key The id<PRJProjectable> key for obj. The key is retained.

*/
- (void)setObject:(PRJRect *)obj forKeyedSubscript:(id<PRJProjectable>)key;

/// Iterates through all entries and applies the rect to the id<PRJProjectable>.
- (void)apply;

NS_ASSUME_NONNULL_END
@end
