//
//  PRJMapping.m
//  Projection
//
//  Created by Mikey Lintz on 2/1/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import "PRJMapping.h"

#import "PRJRect.h"

@implementation PRJMapping {
  NSMapTable *_rectMapping;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _rectMapping = [NSMapTable strongToStrongObjectsMapTable];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@ %p; contents = %@>", NSStringFromClass([self class]),
          self, _rectMapping];
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
    NSAssert(rect.isFullyDefined, @"Attempting to apply underdefined rect: %@", rect);
    CGRect frame = rect.integralFrame;

    view.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    view.bounds = CGRectMake(CGRectGetMinX(view.bounds),
                             CGRectGetMinY(view.bounds),
                             CGRectGetWidth(frame),
                             CGRectGetHeight(frame));
  }
}

#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
  return [_rectMapping countByEnumeratingWithState:state objects:buffer count:len];
}

@end
