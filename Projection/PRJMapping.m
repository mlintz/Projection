//
//  PRJMapping.m
//  Projection
//
//  Created by Mikey Lintz on 2/1/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import "PRJMapping.h"

#import "PRJRect.h"

#import <UIKit/UIKit.h>

@implementation PRJMapping {
  NSMapTable *_rectMapping;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _rectMapping = [NSMapTable strongToStrongObjectsMapTable];
    _bounds = [[PRJRect alloc] init];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p; bounds = %@; contents = %@>", NSStringFromClass([self class]),
          self, self.bounds, _rectMapping];
}

- (void)setObject:(PRJRect *)rect forKeyedSubscript:(UIView *)key {
  NSAssert(key && rect, @"key and rect must be non-nil.");
  [_rectMapping setObject:[rect copy] forKey:key];
}

- (PRJRect *)objectForKeyedSubscript:(UIView *)key {
  PRJRect *rect = [_rectMapping objectForKey:key];
  if (!rect) {
    rect = [[PRJRect alloc] init];
    [_rectMapping setObject:rect forKey:key];
  }
  return rect;
}

- (void)apply {
  for (UIView *view in _rectMapping) {
    PRJRect *rect = [_rectMapping objectForKey:view];
    CGRect integralFrame = CGRectIntegral(rect.frame);

    view.center = CGPointMake(CGRectGetMidX(integralFrame), CGRectGetMidY(integralFrame));
    view.bounds = CGRectMake(0, 0, CGRectGetWidth(integralFrame), CGRectGetHeight(integralFrame));
  }
}

#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
  return [_rectMapping countByEnumeratingWithState:state objects:buffer count:len];
}

@end
