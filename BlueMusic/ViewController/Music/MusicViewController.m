//
//  MusicViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicListViewController.h"
#import "ClockViewController.h"
#import "TMPCheckViewController.h"
#import "SoundSettingViewController.h"


#import "BlueToothManager.h"
@interface MusicViewController ()

@end

@implementation MusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UIImage *logoimage = [UIImage imageNamed:@"music_btn.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.mScrollView addSubview:logo];
    
    
    UIButton *blueBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 115, 114)];
    [blueBtn setBackgroundImage:[UIImage imageNamed:@"music_bluetooth_all_btn.png"] forState:UIControlStateNormal];
    blueBtn.center = CGPointMake(width/2.0, 30 + 29 + logoimage.size.height + 114/2.0);
    [self.mScrollView addSubview:blueBtn];
    
    UIButton *tfBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 115, 114)];
    [tfBtn setBackgroundImage:[UIImage imageNamed:@"music_TF_all_btn.png"] forState:UIControlStateNormal];
    tfBtn.center = CGPointMake(width/2.0, blueBtn.frame.size.height + blueBtn.frame.origin.y + 24 + 114/2.0);
    [self.mScrollView addSubview:tfBtn];
    
    UIButton *clockBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 115, 114)];
    [clockBtn setBackgroundImage:[UIImage imageNamed:@"music_clock_all_btn.png"] forState:UIControlStateNormal];
    clockBtn.center = CGPointMake(width/2.0, tfBtn.frame.size.height + tfBtn.frame.origin.y + 114/2.0 + 24);
    [self.mScrollView addSubview:clockBtn];
    
    UIButton *setBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 59)];
    [setBtn setBackgroundImage:[UIImage imageNamed:@"setting_btn.png"] forState:UIControlStateNormal];
    setBtn.center = CGPointMake(width - 16 - 59/2.0, clockBtn.frame.size.height + clockBtn.frame.origin.y + 11);
    [self.mScrollView addSubview:setBtn];
    if (CGRectGetHeight([UIScreen mainScreen].bounds) < 500)
    self.mScrollView.contentSize = CGSizeMake(0, setBtn.frame.size.height + setBtn.frame.origin.y + 47.0);
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.showsVerticalScrollIndicator = NO;
    
    
    blueBtn.tag = 0;
    tfBtn.tag = 1;
    clockBtn.tag = 2;
    setBtn.tag = 3;
    [blueBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [tfBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [clockBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [setBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[BlueToothManager sharedInstanced] registerBleManagerNotification:self];
}

- (void)btnAction:(UIButton*)btn
{
    if (btn.tag == 0)
    {
        //发送请求music的请求
        
        [[BlueToothManager sharedInstanced] requestMusicBLE];
        MusicListViewController *controller = [[UIStoryboard storyboardWithName:@"MusicViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MusicListViewController"];
        controller.tag = 0;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (btn.tag == 1)
    {
        [[BlueToothManager sharedInstanced] requestMusicTF];
        
        MusicListViewController *controller = [[UIStoryboard storyboardWithName:@"MusicViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MusicListViewController"];
        controller.tag = 1;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (btn.tag == 2)
    {
        [[BlueToothManager sharedInstanced] requestCheckClockTime];
        
        ClockViewController *controller = [[UIStoryboard storyboardWithName:@"MusicViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ClockViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (btn.tag == 3)
    {
        SoundSettingViewController *controller = [[UIStoryboard storyboardWithName:@"SettingViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SoundSettingViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bleManager:(id)manager didCanPushBle:(BOOL)canPush
{
    
}

-(void)bleManager:(id)manager didCanPushTF:(BOOL)canPush
{
    
}


@end
