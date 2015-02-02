//
//  PRJRect.h
//  Projection
//
//  Created by Mikey Lintz on 1/30/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRJRect : NSObject<NSCopying>

@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat right;
@property(nonatomic, assign) CGFloat centerX;
@property(nonatomic, assign) CGFloat width;

@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat centerY;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, assign) CGPoint topLeft;
@property(nonatomic, assign) CGPoint topRight;
@property(nonatomic, assign) CGPoint bottomLeft;
@property(nonatomic, assign) CGPoint bottomRight;
@property(nonatomic, assign) CGPoint center;

@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGRect frame;

@end
