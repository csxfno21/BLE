//
//  TMPCheckViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "TMPCheckViewController.h"

@interface TMPCheckViewController ()

@end

@implementation TMPCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = nil;
    float wx = 0;
    if (self.tag == 0)
    {
        image = [UIImage imageNamed:@"VOC.jpg"];
    }
    else if (self.tag == 1)
    {
        image = [UIImage imageNamed:@"当前温度.jpg"];
    }
    else if (self.tag == 2)
    {
        image = [UIImage imageNamed:@"当前湿度.jpg"];
    }
    else if (self.tag == 3)
    {
        image = [UIImage imageNamed:@"配件购买.jpg"];
    
    }
    else
    {
        image = [UIImage imageNamed:@"音效设置.jpg"];
        wx = 25;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0 - wx/2.0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) + wx, CGRectGetHeight([UIScreen mainScreen].bounds));
    [self.view addSubview:imageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)backAction:(UITapGestureRecognizer*)gesture
{
    CGPoint touchPoint = [gesture locationInView:self.view];
    if (touchPoint.x <= 100 && touchPoint.y <= 50)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
