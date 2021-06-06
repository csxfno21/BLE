//
//  HomeViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "HomeViewController.h"
#import "UINavigationController+YRBackGesture.h"
#import "MusicViewController.h"
#import "AirViewController.h"
#import "CheckViewController.h"
#import "SettingViewController.h"


#import "BlueToothManager.h"
@interface HomeViewController ()<BlueToothManagerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setEnableBackGesture:YES];
    [[BlueToothManager sharedInstanced] registerBleManagerNotification:self];
    
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UIImage *logoimage = [UIImage imageNamed:@"home_logo.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.mScrollerView addSubview:logo];
    
    
    UIButton *musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 87, 113)];
    [musicBtn setBackgroundImage:[UIImage imageNamed:@"home_musice_btn.png"] forState:UIControlStateNormal];
    musicBtn.center = CGPointMake(width/2.0, 30 + 29 + logoimage.size.height + 113/2.0);
    [self.mScrollerView addSubview:musicBtn];
    
    UIButton *airBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 87, 113)];
    [airBtn setBackgroundImage:[UIImage imageNamed:@"home_air_btn.png"] forState:UIControlStateNormal];
    airBtn.center = CGPointMake(width/2.0, musicBtn.frame.size.height + musicBtn.frame.origin.y + 24 + 113/2.0);
    [self.mScrollerView addSubview:airBtn];
    
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 87, 113)];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"home_+_btn.png"] forState:UIControlStateNormal];
    checkBtn.center = CGPointMake(width/2.0, airBtn.frame.size.height + airBtn.frame.origin.y + 113/2.0 + 24);
    [self.mScrollerView addSubview:checkBtn];
    
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 38)];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"home_setting_btn.png"] forState:UIControlStateNormal];
    setBtn.center = CGPointMake(width - 16 - 46/2.0, checkBtn.frame.size.height + checkBtn.frame.origin.y + 11);
    [self.mScrollerView addSubview:setBtn];
    
    
    UIButton *powerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 51)];
    [powerBtn setBackgroundImage:[UIImage imageNamed:@"btn_open.png"] forState:UIControlStateNormal];
    powerBtn.center = CGPointMake(16 + 50/2.0, checkBtn.frame.size.height + checkBtn.frame.origin.y + 11);
    [self.mScrollerView addSubview:powerBtn];
    
    if (CGRectGetHeight([UIScreen mainScreen].bounds) < 500)
    {
       self.mScrollerView.contentSize = CGSizeMake(0, setBtn.frame.size.height + setBtn.frame.origin.y + 47.0);
    }
 
    self.mScrollerView.showsHorizontalScrollIndicator = NO;
    self.mScrollerView.showsVerticalScrollIndicator = NO;
    
    
    musicBtn.tag = 0;
    airBtn.tag = 1;
    checkBtn.tag = 2;
    setBtn.tag = 3;
    powerBtn.tag = 4;
    [musicBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [airBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [checkBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [powerBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction:(UIButton*)btn
{
    if (btn.tag == 0)
    {
        MusicViewController *controller = [[UIStoryboard storyboardWithName:@"MusicViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MusicViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (btn.tag == 1)
    {
        [[BlueToothManager sharedInstanced] requestAIRSetting];
        
        AirViewController *controller = [[UIStoryboard storyboardWithName:@"AirViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AirViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (btn.tag == 2)
    {
        
        [[BlueToothManager sharedInstanced] requestEnvironmentShow];
        
        CheckViewController *controller = [[UIStoryboard storyboardWithName:@"CheckViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"CheckViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (btn.tag == 3)
    {
        SettingViewController *controller = [[UIStoryboard storyboardWithName:@"SettingViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (btn.tag == 4)
    {
        
    }
}


- (void)bleManager:(id)manager didDisConnect:(PeripheralEntity *)peripheralEntity
{
    //掉线了
}






- (void)didReceiveMemoryWarning
{
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
