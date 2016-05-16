//
//  PRJCategories.m
//  ManualLayoutDemo
//
//  Created by Mikey Lintz on 6/2/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import "PRJCategories.h"

#import "PRJRect.h"

@implementation UIView (PRJProjectable)

- (void)prj_apply:(PRJRect *)rect {
  CGRect frame = rect.roundedFrame;
  self.bounds = CGRectMake(CGRectGetMinX(self.bounds),
                           CGRectGetMinY(self.bounds),
                           CGRectGetWidth(frame),
                           CGRectGetHeight(frame));
  CGFloat centerX = CGRectGetMinX(frame) + CGRectGetWidth(frame) * self.layer.anchorPoint.x;
  CGFloat centerY = CGRectGetMinY(frame) + CGRectGetHeight(frame) * self.layer.anchorPoint.y;
  self.center = CGPointMake(centerX, centerY);
}

@end

@implementation CALayer (PRJProjectable)

- (void)prj_apply:(PRJRect *)rect {
  CGRect frame = rect.roundedFrame;
  self.bounds = CGRectMake(CGRectGetMinX(self.bounds),
                           CGRectGetMinY(self.bounds),
                           CGRectGetWidth(frame),
                           CGRectGetHeight(frame));

  CGFloat positionX = CGRectGetMinX(frame) + CGRectGetWidth(frame) * self.anchorPoint.x;
  CGFloat positionY = CGRectGetMinY(frame) + CGRectGetHeight(frame) * self.anchorPoint.y;
  self.position = CGPointMake(positionX, positionY);
}

@end

@implementation UIViewController (PRJProjectable)

- (void)prj_apply:(PRJRect *)rect {
  [self.view prj_apply:rect];
}

@end

@implementation UIView (PRJSizing)

- (PRJRect *)fittingRectWithSize:(CGSize)size {
  PRJRect *rect = [[PRJRect alloc] init];
  rect.size = [self sizeThatFits:size];
  return rect;
}

- (PRJRect *)fittingRectWithWidth:(CGFloat)width {
  return [self fittingRectWithSize:CGSizeMake(width, 0)];
}

- (PRJRect *)fittingRect {
  return [self fittingRectWithSize:CGSizeZero];
}

@end

@implementation PRJRect (PRJSizing)

- (instancetype)sizeToView:(UIView *)view size:(CGSize)size {
  PRJRect *rect = [view fittingRectWithSize:size];
  self.size = rect.size;
  return self;
}

- (instancetype)sizeToView:(UIView *)view width:(CGFloat)width {
  [self sizeToView:view size:CGSizeMake(width, 0)];
  return self;
}

- (instancetype)sizeToView:(UIView *)view {
  [self sizeToView:view size:CGSizeZero];
  return self;
}

@end
