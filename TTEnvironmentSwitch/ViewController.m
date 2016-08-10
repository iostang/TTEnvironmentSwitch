//
//  ViewController.m
//  TTEnvironmentSwitch
//
//  Created by TangChi on 16/8/8.
//  Copyright © 2016年 tangchi. All rights reserved.
//

#import "ViewController.h"
#import "TTNetWorkClient.h"
#import "TTDebugView.h"
#import "TTHUDView.h"

#define API @"onebox/weather/query?cityname=%E6%B8%A9%E5%B7%9E&key=JH24409331f12e181acc3b513c17068e38"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.330 alpha:1.000];
    btn.frame = (CGRect){CGRectGetWidth(self.view.bounds)/2 - 40, 150, 80, 80};
    btn.layer.cornerRadius = 40;
    [btn setTitle:@"GET" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(GETAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)GETAction
{
    [TTHUDView showLoadingToView:self.view];
    
    [[TTNetWorkClient shareClient]GET:API
                           parameters:nil
                              success:^(id responseObject) {
                                  
                                  [TTHUDView hideLoadingFromView:self.view delay:0.5];
                                  [TTHUDView showHUDToViewCenter:self.view message:@"请求成功"];
                                  
                              } failure:^(NSError *error) {
                                  
                                  [TTHUDView hideLoadingFromView:self.view];
                                  [TTHUDView showHUDToViewCenter:self.view message:@"请求失败"];
                                  [TTHUDView showNetworkToView:self.view position:CGPointZero];
                                  
                              }];
    
}

@end
