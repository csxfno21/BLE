//
//  MusicCell.h
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *mSubTitleLabel;
@end
