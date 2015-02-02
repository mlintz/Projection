//
//  ViewController.m
//  ManualLayoutDemo
//
//  Created by Mikey Lintz on 1/30/15.
//  Copyright (c) 2015 Mikey Lintz. All rights reserved.
//

#import "ViewController.h"

#import "PRJProjection.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)loadView {
  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor whiteColor];
  self.view = view;
  
  UIView *childView0 = [[UIView alloc] init];
  childView0.backgroundColor = [UIColor cyanColor];
  [view addSubview:childView0];
  
  UIView *childView1 = [[UIView alloc] init];
  childView1.backgroundColor = [UIColor magentaColor];
  [view addSubview:childView1];
  
  UIView *childView2 = [[UIView alloc] init];
  childView2.transform = CGAffineTransformMakeRotation(M_PI_4);
  childView2.backgroundColor = [UIColor brownColor];
  [view addSubview:childView2];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  [self.view prj_applyProjection:^(PRJMapping *mapping) {
    UIView *childView0 = [self.view.subviews firstObject];
    mapping[childView0].height = 100;
    mapping[childView0].width = 100;
    mapping[childView0].center = mapping.bounds.center;
    
    UIView *childView1 = self.view.subviews[1];
    mapping[childView1].bottomLeft = mapping[childView0].topRight;
    mapping[childView1].size = mapping[childView0].size;
    
    UIView *childView2 = self.view.subviews[2];
    mapping[childView2].center = mapping[childView1].center;
    mapping[childView2].height = mapping[childView1].height - 40;
    mapping[childView2].width = mapping[childView2].height;
  }];
}

@end
