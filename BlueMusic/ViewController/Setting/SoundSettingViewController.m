//
//  SoundSettingViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "SoundSettingViewController.h"
#import "BlueToothManager.h"

@interface SoundSettingViewController ()

@end

@implementation SoundSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UIImage *logoimage = [UIImage imageNamed:@"head_sound settings.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.mScrollView addSubview:logo];
    
    
    UIButton *btn0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 82, 109)];
    [btn0 setBackgroundImage:[UIImage imageNamed:@"btn_powerful.png"] forState:UIControlStateNormal];
    btn0.center = CGPointMake(width/2.0, 30 + 29 + logoimage.size.height + 109/2.0);
    [self.mScrollView addSubview:btn0];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 82, 109)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_standard.png"] forState:UIControlStateNormal];
    btn1.center = CGPointMake(width/2.0, btn0.frame.size.height + btn0.frame.origin.y + 24 + 109/2.0);
    [self.mScrollView addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 82, 109)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"btn_soothing.png"] forState:UIControlStateNormal];
    btn2.center = CGPointMake(width/2.0, btn1.frame.size.height + btn1.frame.origin.y + 109/2.0 + 24);
    [self.mScrollView addSubview:btn2];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    label.textColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    label.text = @"小音量时增强低音";
    label.textAlignment = NSTextAlignmentCenter;
    [self.mScrollView addSubview:label];
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
    label.frame = CGRectMake(0, 0, size.width + 51 + 5, 20);
    label.center = CGPointMake(width/2 - (51)/2.0,btn2.frame.size.height + btn2.frame.origin.y + 40);
    
    UISwitch *switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(label.frame.origin.x + size.width + 51, label.center.y - 31/2.0, 51, 31)];
    switchBtn.tag = 1000;
    [self.mScrollView addSubview:switchBtn];
    

    self.mScrollView.contentSize = CGSizeMake(0, switchBtn.frame.size.height + switchBtn.frame.origin.y + 47.0);
    self.mScrollView.showsHorizontalScrollIndicator = NO;
    self.mScrollView.showsVerticalScrollIndicator = NO;
    
    
    btn0.tag = 0;
    btn1.tag = 1;
    btn2.tag = 2;
    [btn0 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [[BlueToothManager sharedInstanced] requestAudioStepSetting];
}
- (void)btnAction:(UIButton*)btn
{
    if (btn.tag == 0) //强劲
    {
        NSString *res = [self swithData];
        [[BlueToothManager sharedInstanced] requestAudioStepChange:@"02" withData2:res];
    }
    else if (btn.tag == 1) //标准
    {
        NSString *res = [self swithData];
        [[BlueToothManager sharedInstanced] requestAudioStepChange:@"00" withData2:res];
    }
    else if (btn.tag == 2) //舒缓
    {
        NSString *res = [self swithData];
        [[BlueToothManager sharedInstanced] requestAudioStepChange:@"01" withData2:res];
    }
    
}

- (NSString *)swithData
{
    NSString *res = nil;
    for (UIView *view in self.mScrollView.subviews)
    {
        if ([view isKindOfClass:[UISwitch class]])
        {
            UISwitch *s = (UISwitch *)view;
            if (s.on)
            {
                res = @"01";
            }
            else
                res = @"00";
        }
    }
    return res;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
