//
//  AirViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "AirViewController.h"

@interface AirViewController ()

@end

@implementation AirViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UIImage *logoimage = [UIImage imageNamed:@"air_header.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.mScrollView addSubview:logo];
    
    
    UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 87, 113)];
    [btn0 setBackgroundImage:[UIImage imageNamed:@"air_normalmode_btn.png"] forState:UIControlStateNormal];
    btn0.center = CGPointMake(width/2.0, 30 + 29 + logoimage.size.height + 113/2.0);
    [self.mScrollView addSubview:btn0];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 87, 113)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"air_mute_btn.png"] forState:UIControlStateNormal];
    btn1.center = CGPointMake(width/2.0, btn0.frame.size.height + btn0.frame.origin.y + 24 + 113/2.0);
    [self.mScrollView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 87, 113)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"air_supermode_btn.png"] forState:UIControlStateNormal];
    btn2.center = CGPointMake(width/2.0, btn1.frame.size.height + btn1.frame.origin.y + 113/2.0 + 24);
    [self.mScrollView addSubview:btn2];

    if (CGRectGetHeight([UIScreen mainScreen].bounds) < 500)
    self.mScrollView.contentSize = CGSizeMake(0, btn2.frame.size.height + btn2.frame.origin.y + 47.0);
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.showsVerticalScrollIndicator = NO;
    
    
    btn0.tag = 0;
    btn1.tag = 1;
    btn2.tag = 2;

    [btn0 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnAction:(UIButton*)btn
{

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
