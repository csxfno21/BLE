//
//  BaseViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addBackBtn
{
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, 24, 24)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addTopLine
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth([UIScreen mainScreen].bounds), 1)];
    lineView.backgroundColor = [UIColor colorWithRed:203.0/255.0 green:206.0/255.0 blue:207.0/255.0 alpha:1.0];
    [self.view addSubview:lineView];
}
- (void)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
