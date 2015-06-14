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
  CGRect frame = rect.integralFrame;
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
  CGRect frame = rect.integralFrame;
  self.bounds = CGRectMake(CGRectGetMinX(self.bounds),
                           CGRectGetMinY(self.bounds),
                           CGRectGetWidth(frame),
                           CGRectGetHeight(frame));

  CGFloat positionX = CGRectGetMinX(frame) + CGRectGetWidth(frame) * self.anchorPoint.x;
  CGFloat positionY = CGRectGetMinY(frame) + CGRectGetHeight(frame) * self.anchorPoint.y;
  self.position = CGPointMake(positionX, positionY);
}

@end
