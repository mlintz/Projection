//
//  UIView+PRJProjection.h
//  Projection
//
//  Created by Mikey Lintz on 2/1/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PRJMapping;

typedef void (^PRJConfigurationBlock)(PRJMapping *mapping);

@interface UIView (PRJConvenience)

- (void)prj_applyProjection:(PRJConfigurationBlock)configurationBlock;
- (void)prj_applyProjectionWithSize:(CGSize)size configuration:(PRJConfigurationBlock)configurationBlock;
- (void)prj_applyProjectionWithBounds:(CGRect)bounds configuration:(PRJConfigurationBlock)configurationBlock;

@end
