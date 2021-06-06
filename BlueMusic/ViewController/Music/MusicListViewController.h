//
//  MusicListViewController.h
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BaseViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "BlueAudioPlayerManager.h"

@interface MusicListViewController : BaseViewController<MPMediaPickerControllerDelegate,AVAudioPlayerDelegate,BlueAudioPlayerDelegate>
{

}
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *mAllTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mCurrentTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *mSlider;

@property (weak, nonatomic) IBOutlet UIButton *mLastActionBtn;
@property (weak, nonatomic) IBOutlet UIButton *mPlayActionBtn;
@property (weak, nonatomic) IBOutlet UIButton *mNextActionBtn;



@property (nonatomic)NSInteger tag;
@end
