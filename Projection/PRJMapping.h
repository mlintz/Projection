//
//  PRJMapping.h
//  Projection
//
//  Created by Mikey Lintz on 2/1/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRJRect;

@interface PRJMapping : NSObject

@property(nonatomic, readonly) PRJRect *bounds;

- (PRJRect *)objectForKeyedSubscript:(UIView *)key;
- (void)setObject:(PRJRect *)obj forKeyedSubscript:(UIView *)key;

- (void)apply;

@end
