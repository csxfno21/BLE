//
//  SelectedSettingMusicViewController.h
//  BlueMusic
//
//  Created by csxfno21 on 15-3-17.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectedSettingMusicViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end
