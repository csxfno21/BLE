//
//  ClockRingViewController.h
//  BlueMusic
//
//  Created by company on 15-4-2.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BaseViewController.h"

static NSString *const POST_RING = @"POST_RING";

@interface ClockRingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@end
