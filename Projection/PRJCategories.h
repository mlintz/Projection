//
//  PRJCategories.h
//  ManualLayoutDemo
//
//  Created by Mikey Lintz on 6/2/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PRJMapping.h"

@interface UIView (PRJProjectable)<PRJProjectable>
@end

@interface CALayer (PRJProjectable)<PRJProjectable>
@end

@interface UIViewController (PRJProjectable)<PRJProjectable>
@end

@interface UIView (PRJSizing)
NS_ASSUME_NONNULL_BEGIN
/// Returns a rect with size equal to [self sizeThatFits:size];
- (PRJRect *)fittingRectWithSize:(CGSize)size;
/// Equivalent to [self fittingRectWithSize:CGSizeMake(width, 0)];
- (PRJRect *)fittingRectWithWidth:(CGFloat)width;
/// Equivalent to [self fittingRectWithSize:CGSizeZero];
- (PRJRect *)fittingRect;
NS_ASSUME_NONNULL_END
@end
