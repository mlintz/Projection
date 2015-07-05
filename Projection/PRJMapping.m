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

- (void)setObject:(PRJRect *)rect forKeyedSubscript:(id<PRJProjectable>)key {
  NSAssert(key && rect, @"key and rect must be non-nil.");
  NSAssert(![_rectMapping objectForKey:key], @"rect previously set for key: %@", key);
  [_rectMapping setObject:[rect copy] forKey:key];
}

- (PRJRect *)objectForKeyedSubscript:(id<PRJProjectable>)key {
  PRJRect *rect = [_rectMapping objectForKey:key];
  if (!rect) {
    rect = [[PRJRect alloc] init];
    [_rectMapping setObject:rect forKey:key];
  }
  return rect;
}

- (void)apply {
  for (id<PRJProjectable> projectable in _rectMapping) {
    PRJRect *rect = [_rectMapping objectForKey:projectable];
    NSAssert(rect.isFullyDefined, @"Attempting to apply underdefined rect: %@", rect);
    [projectable prj_apply:rect];
  }
}

#pragma mark NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
  return [_rectMapping countByEnumeratingWithState:state objects:buffer count:len];
}

@end
