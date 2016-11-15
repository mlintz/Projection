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
  self.cyanView.layer.position = CGPointZero;
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

//  [self.view prj_applyProjection:^(PRJMapping *mapping, PRJRect *viewBounds) {
//    mapping[self.cyanView].height = 100;
//    mapping[self.cyanView].width = 100;
//    mapping[self.cyanView].center = viewBounds.center;
//    
//    mapping[self.magentaView].bottomLeft = mapping[self.cyanView].topRight;
//    mapping[self.magentaView].size = mapping[self.cyanView].size;
//    
//    mapping[self.brownView].center = mapping[self.magentaView].center;
//    mapping[self.brownView].height = mapping[self.magentaView].height - 40;
//    mapping[self.brownView].width = mapping[self.brownView].height;
//
//    mapping[self.yellowLayer].center = mapping[self.brownView].center;
//    mapping[self.yellowLayer].size = mapping[self.brownView].size;
//  }];
	
  [self.cyanView prj_applySingleProjection:^(PRJRect * _Nonnull frame) {
	frame.height = 100;
	frame.width = 100;
	frame.center = self.view.prj_frame.center;
  }];

  [self.magentaView prj_applySingleProjection:^(PRJRect * _Nonnull frame) {
	frame.bottomLeft = self.cyanView.prj_frame.topRight;
	frame.size = self.cyanView.prj_frame.size;
  }];
	
  [self.brownView prj_applySingleProjection:^(PRJRect * _Nonnull frame) {
	frame.center = self.magentaView.prj_frame.center;
	frame.height = self.magentaView.prj_frame.height - 40;
	frame.width = frame.height;
	  
	// MUST do this using the PRJRect supplied here, because after it is applied, the transform is applied
	// This changes the frame, and therefore changes our PRJRect if we attempt to ask for it, from the view.
	// I believe this to be the desired behavior regarding transforms with this syntax.
	PRJRect* yellowLayerRect = [[PRJRect alloc] init];
	yellowLayerRect.center = frame.center;
	yellowLayerRect.size = frame.size;
	[self.yellowLayer prj_apply:yellowLayerRect];
  }];

}

@end
