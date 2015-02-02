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
  
  UIView *cyanView = [[UIView alloc] init];
  cyanView.backgroundColor = [UIColor cyanColor];
  [view addSubview:cyanView];
  
  UIView *magentaView = [[UIView alloc] init];
  magentaView.backgroundColor = [UIColor magentaColor];
  [view addSubview:magentaView];
  
  UIView *brownView = [[UIView alloc] init];
  brownView.transform = CGAffineTransformMakeRotation(M_PI_4);
  brownView.backgroundColor = [UIColor brownColor];
  [view addSubview:brownView];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  [self.view prj_applyProjection:^(PRJMapping *mapping) {
    UIView *cyanView = [self.view.subviews firstObject];
    mapping[cyanView].height = 100;
    mapping[cyanView].width = 100;
    mapping[cyanView].center = mapping.bounds.center;
    
    UIView *magentaView = self.view.subviews[1];
    mapping[magentaView].bottomLeft = mapping[cyanView].topRight;
    mapping[magentaView].size = mapping[cyanView].size;
    
    UIView *brownView = self.view.subviews[2];
    mapping[brownView].center = mapping[magentaView].center;
    mapping[brownView].height = mapping[magentaView].height - 40;
    mapping[brownView].width = mapping[brownView].height;
  }];
}

@end
