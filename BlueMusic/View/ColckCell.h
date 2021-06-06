//
//  ColckCell.h
//  BlueMusic
//
//  Created by csxfno21 on 15-2-19.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColckCell;
@protocol ClockCellDelegate <NSObject>

- (void)colckCell:(ColckCell *)cell canEditClock:(BOOL)isCan;

- (void)colckCell:(ColckCell *)cell isOn:(BOOL)isOn withIndex:(int)index;

@end

@interface ColckCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mColockTime;
@property (weak, nonatomic) IBOutlet UIButton *mEditActionbtn;
@property (weak, nonatomic) IBOutlet UISwitch *mSwitchActionBtn;
@property (assign, nonatomic) id<ClockCellDelegate> delegate;
@end
