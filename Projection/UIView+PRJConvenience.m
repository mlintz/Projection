//
//  UIView+PRJConvenience.m
//  Projection
//
//  Created by Mikey Lintz on 2/1/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import "UIView+PRJConvenience.h"

#import "PRJMapping.h"
#import "PRJRect.h"

@implementation UIView (PRJConvenience)

- (void)prj_applyProjection:(PRJConfigurationBlock)configurationBlock {
  [self prj_applyProjectionWithBounds:self.bounds configuration:configurationBlock];
}

- (void)prj_applyProjectionWithSize:(CGSize)size
                      configuration:(PRJConfigurationBlock)configurationBlock {
  CGRect bounds = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), size.width, size.height);
  [self prj_applyProjectionWithBounds:bounds configuration:configurationBlock];
}

- (void)prj_applyProjectionWithBounds:(CGRect)bounds
                        configuration:(PRJConfigurationBlock)configurationBlock {
  NSAssert(configurationBlock, @"configurationBlock must be non-nil");
  PRJMapping *mapping = [[PRJMapping alloc] init];
  PRJRect *viewBoundsRect = [[PRJRect alloc] init];
  viewBoundsRect.frame = bounds;
  
  configurationBlock(mapping, viewBoundsRect);
  [mapping apply];
}

@end
