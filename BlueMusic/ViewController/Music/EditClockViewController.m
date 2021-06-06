//
//  EditClockViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15/4/1.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "EditClockViewController.h"

@interface EditClockViewController ()
{
    
}
@end

@implementation EditClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBtn];
    [self addTopLine];
    
}

- (IBAction)confirmAction:(id)sender
{
    NSDate *select = [self.datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    _dateAndTime =  [dateFormatter stringFromDate:select];
    [[NSNotificationCenter defaultCenter] postNotificationName:POST_TIME_NOTI object:_dateAndTime];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
