//
//  WorkTimeView.m
//  BlueMusic
//
//  Created by company on 15-4-2.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "WorkTimeView.h"

@implementation WorkTimeView

- (IBAction)setTime1:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(workTimeView:withString:)])
    {
        [self.delegate workTimeView:self withString:@"10"];
    }
}

- (IBAction)setTime2:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(workTimeView:withString:)])
    {
        [self.delegate workTimeView:self withString:@"05"];
    }
}

- (IBAction)setTime3:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(workTimeView:withString:)])
    {
        [self.delegate workTimeView:self withString:@"01"];
    }
}
@end
