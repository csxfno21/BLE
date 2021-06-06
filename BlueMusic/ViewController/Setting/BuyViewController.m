//
//  BuyViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-19.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BuyViewController.h"

@interface BuyViewController ()

@end

@implementation BuyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UIImage *logoimage = [UIImage imageNamed:@"head_buy  accessories.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.view addSubview:logo];
    [self addBackBtn];
    [self addTopLine];

}
- (IBAction)jdAction:(id)sender
{
    
}
- (IBAction)tmAction:(id)sender
{
    
}
- (IBAction)tbAction:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
