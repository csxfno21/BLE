//
//  ColckCell.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-19.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "ColckCell.h"

@implementation ColckCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editClock:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(colckCell:canEditClock:)])
    {
        [self.delegate colckCell:self canEditClock:YES];
    }
}

- (IBAction)switchClock:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(colckCell:isOn:withIndex:)])
    {
        [self.delegate colckCell:self isOn:self.mSwitchActionBtn.on withIndex:self.tag];
    }
}

@end
