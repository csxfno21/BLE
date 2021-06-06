//
//  MusicViewController.h
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BaseViewController.h"
#import "BlueToothManager.h"

@interface MusicViewController : BaseViewController<BlueToothManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@end
