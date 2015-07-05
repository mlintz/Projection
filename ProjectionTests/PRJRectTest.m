//
//  PRJRectTest.m
//  ManualLayoutDemo
//
//  Created by Mikey Lintz on 7/4/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import "PRJProjection.h"
#import <XCTest/XCTest.h>

@interface PRJRectTest : XCTestCase
@end

@implementation PRJRectTest

- (void)setUp {
  [PRJRect debugSetMinFloat:0.25];
}

- (void)testMaintainLengthInsteadOfCenterIfInConflict {
  PRJRect *rect = [[PRJRect alloc] init];
  rect.centerX = 0.25;
  rect.width = 0.25;

  // Ignore
  rect.top = 0;
  rect.height = 0;

  UIView *view = [[UIView alloc] init];
  [view prj_apply:rect];

  XCTAssert(CGRectEqualToRect(view.frame, CGRectMake(0.25, 0, 0.25, 0)));
}

- (void)testRoundLengthUp {
  PRJRect *rect = [[PRJRect alloc] init];
  rect.left = 0;
  rect.width = 0.01;

  // Ignore
  rect.top = 0;
  rect.height = 0;

  UIView *view = [[UIView alloc] init];
  [view prj_apply:rect];

  XCTAssert(CGRectEqualToRect(view.frame, CGRectMake(0, 0, 0.25, 0)));
}

- (void)testMinAndMaxMetricsRoundTheSame {
  PRJRect *rectA = [[PRJRect alloc] init];
  rectA.left = 0;
  rectA.width = 0.24;

  PRJRect *rectB = [[PRJRect alloc] init];
  rectB.left = rectA.right;
  rectB.width = 0.01;

  // Ignore
  rectA.top = 0;
  rectA.height = 0;
  rectB.top = 0;
  rectB.height = 0;

  UIView *viewA = [[UIView alloc] init];
  [viewA prj_apply:rectA];

  UIView *viewB = [[UIView alloc] init];
  [viewB prj_apply:rectB];

  XCTAssert(CGRectGetMaxX(rectA.frame) == CGRectGetMinX(rectB.frame));
  XCTAssert(CGRectGetWidth(rectB.frame) == 0.25);
}

@end

//Constraints:
//- Length should ~always~ round up if set explicitly (to avoid cutting off text)
//- A metric property shouldn't be read as different values
//- If two views are set to touch (e.g. foo.top = bar.bottom) or (foo.top = bar.top), then they should be rendered touching... no gaps or overlap.
//- If length is set to 1, then length must be 1
//- If length is 0, then it must be 0
//- If length is positive, then it must be positive
//- If two views are set to have same center, then they ~can~ deviate if one's length has an odd number of units and the other length has an even number of units
//
//Policy:
//- Always ~ceiling~ length on set
//- Don't round min, center, or max on set
//- On get, calculate the value based on existing metrics
//- On apply, calculate min and max and ~round~ each of them
//
//1.
//a = Rect()
//a.center = 1
//a.length = 1  // Respect length over center
//print(a) // min 1, center 1.5, max 2, length 1
//
//2.
//a = Rect()
//a.center = 0.5
//a.length = 1
//print(a) // min 0, center 0.5, max 1, length 1
//
//3.
//a = Rect()
//a.center = 1
//a.length = 2
//print (a)  // min 0, center 1, max 1, length = 2
//
//4.
//a = Rect()
//a.min = 0.1
//a.length = 1
//print(a)  // min = 0, center = 0.5, max = 1, length = 1
//
//5.
//a = Rect()
//a.min = 0.1
//a.length = 0
//print(a)  // min = 0, center = 0, max = 0, length = 0
//
//6.
//a = Rect()
//b = Rect()
//a.center = 1
//b.center = a.center
//a.length = 1
//b.length = 2
//print(a)  // min 0, center 0.5, max 1, length 1
//print(b)  // min 0, center 1, max 2, length 2
//
//7.
//a = Rect()
//b = Rect()
//a.center = 1
//print(a.center) // 1
//a.length = 1
//print(a.center) // 0.5
//// This is an invalid API. Therefore, we must round at the end
//// Or we could just have .center and apply be different
//
//8.
//a = Rect()
//b = Rect()
//a.min = 0
//a.length = 5.6
//b.min = a.max // 5.6
//b.length = 2
//print(a)  // min 0, length 6, max 6, center 3
//print(b)  // min 6, length 2, max 8, center 7
//
//9.
//a = Rect()
//a.center = 0.9
//a.length = 1
//print(a)  // min 0, length 1, max 1
//
//10.
//a.min = 0
//a.length = 5.4
//print(a)  // min 0, length 5, max 5, center 2.5
//
//11.
//a.length = 1
//a.center = 1.2
//
//
