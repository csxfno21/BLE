//
//  ClockViewController.h
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BaseViewController.h"
#import "CMPopTipView.h"

@interface ClockViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (strong, nonatomic) IBOutlet UILabel *mRingLabel;
@property (nonatomic,strong)CMPopTipView *popMenuView;
@property (strong, nonatomic) IBOutlet UIButton *workTimeBtn;

@property (strong, nonatomic) IBOutlet UIButton *ringBtn;
@property (strong, nonatomic) IBOutlet UILabel *workTimeLabel;
@end
