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
@property(nonatomic, strong) UIView *cyanView;
@property(nonatomic, strong) UIView *magentaView;
@property(nonatomic, strong) UIView *brownView;
@property(nonatomic, strong) CALayer *yellowLayer;
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
  
  self.cyanView = [[UIView alloc] init];
  self.cyanView.backgroundColor = [UIColor cyanColor];
  [self.view addSubview:self.cyanView];
  
  self.magentaView = [[UIView alloc] init];
  self.magentaView.backgroundColor = [UIColor magentaColor];
  [self.view addSubview:self.magentaView];
  
  self.brownView = [[UIView alloc] init];
  self.brownView.transform = CGAffineTransformMakeRotation(M_PI_4);
  self.brownView.backgroundColor = [UIColor brownColor];
  [self.view addSubview:self.brownView];

  self.yellowLayer = [[CALayer alloc] init];
  self.yellowLayer.backgroundColor = [[UIColor yellowColor] CGColor];
  self.yellowLayer.anchorPoint = CGPointMake(0.25f, 0.25f);
  [self.view.layer addSublayer:self.yellowLayer];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  [self.view prj_applyProjection:^(PRJMapping *mapping, PRJRect *viewBounds) {
    mapping[self.cyanView].height = 100;
    mapping[self.cyanView].width = 100;
    mapping[self.cyanView].center = viewBounds.center;
    
    mapping[self.magentaView].bottomLeft = mapping[self.cyanView].topRight;
    mapping[self.magentaView].size = mapping[self.cyanView].size;
    
    mapping[self.brownView].center = mapping[self.magentaView].center;
    mapping[self.brownView].height = mapping[self.magentaView].height - 40;
    mapping[self.brownView].width = mapping[self.brownView].height;

    mapping[self.yellowLayer].center = mapping[self.brownView].center;
    mapping[self.yellowLayer].size = mapping[self.brownView].size;
  }];
}

@end
