//
//  MusicListViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicCell.h"
#import "BlueToothManager.h"

@interface MusicListViewController ()

@property(nonatomic,strong)NSArray *lists;
@property(nonatomic,strong)MPMusicPlayerController *myMusicPlayer;
@property(nonatomic,strong)MPMediaPickerController *mediaPicker;
@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addTopLine];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    UIImage *logoimage = [UIImage imageNamed:@"head_bluetooth.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.view addSubview:logo];

    [self.mSlider setMinimumTrackImage:[[UIImage imageNamed:@"line_bluetooth_song_progress.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 0)] forState:UIControlStateNormal];
    
    [self.mSlider setMaximumTrackImage:[[UIImage imageNamed:@"line_bluetooth_song_progress_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 4)] forState:UIControlStateNormal];
    
    [self.mSlider setThumbImage:[UIImage imageNamed:@"btn_song_progresspoint.png"] forState:UIControlStateNormal];
    [self.mSlider addTarget:self action:@selector(musicProgressChanged:) forControlEvents:UIControlEventValueChanged];
    
    [[BlueAudioPlayerManager sharedInstanced] registerBleAudioPlayerManagerNotification:self];

#pragma mark - 获取本地音乐列表
    self.lists = [[BlueAudioPlayerManager sharedInstanced] getMusicList];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   static NSString *identifier = @"MusicCell";
    MusicCell *cell = (MusicCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.textColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    id obj = self.lists[indexPath.row];
    if ([obj isKindOfClass:[MPMediaItem class]])
    {
        MPMediaItem *song = (MPMediaItem *)obj;
        cell.mIndexLabel.text = [NSString stringWithFormat:@"%d",indexPath.row + 1];
        cell.mTitleLabel.text = [song valueForProperty:MPMediaItemPropertyTitle];
        cell.mSubTitleLabel.text = [song valueForProperty:MPMediaItemPropertyArtist];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id obj = self.lists[indexPath.row];
    if ([obj isKindOfClass:[MPMediaItem class]])
    {
        [[BlueAudioPlayerManager sharedInstanced] playWithIndex:indexPath.row];
    }
}

/*!
 *  @author csxfno21, 15-04-03 11:04:07
 *
 *  @brief  手动调节音乐进度
 *
 *  @param sender 进度条
 *
 *  @since 1.0
 */
- (void)musicProgressChanged:(UISlider *)slider
{
    float value = slider.value;
    [[BlueAudioPlayerManager sharedInstanced] musicProgressChanged:value];
}

#pragma mark - 单曲循环
- (IBAction)repeatMusic:(id)sender
{
    if (self.tag == 0)
    {
        [[BlueAudioPlayerManager sharedInstanced] repeate];
    }
    else
    {
        [[BlueToothManager sharedInstanced] requestRepeat];
    }
    
}

#pragma mark - 暂停或播放音乐
- (IBAction)playOrPauseMusic:(id)sender
{
    if (self.tag == 0)
    {
        [[BlueAudioPlayerManager sharedInstanced] playOrPause];
    }
    else
    {
        [[BlueToothManager sharedInstanced] requestPlayOrPause];
    }
    
}

#pragma mark - 前一首歌曲
- (IBAction)PrevMusic:(id)sender
{
    if (self.tag == 0)
    {
        [[BlueAudioPlayerManager sharedInstanced] playPre];
    }
    else
    {
        [[BlueToothManager sharedInstanced] requestPrev];
    }
    
}

#pragma mark - 后一首歌曲
- (IBAction)nextMusic:(id)sender
{
    if (self.tag == 0)
    {
        [[BlueAudioPlayerManager sharedInstanced] playNext];
    }
    else
    {
        [[BlueToothManager sharedInstanced] requestNext];
    }
    
}

#pragma mark - 随机播放
- (IBAction)randomMusic:(id)sender
{
    if (self.tag == 0)
    {
        [[BlueAudioPlayerManager sharedInstanced] playRandom];
    }
    else
    {
        [[BlueToothManager sharedInstanced] requestRandom];
    }
    
}


-(void)BlueAudioPlayerManager:(BlueAudioPlayerManager *)manager withCurrentTime:(NSString *)currentTime
{
    [self.mCurrentTimeLabel setText:currentTime];
}

-(void)BlueAudioPlayerManager:(BlueAudioPlayerManager *)manager withTotalTime:(NSString *)totalTime
{
    [self.mAllTimeLabel setText:totalTime];
}

-(void)BlueAudioPlayerManager:(BlueAudioPlayerManager *)manager withProgress:(float)progress
{
    [self.mSlider setValue:progress animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[BlueAudioPlayerManager sharedInstanced] unRegisterBleAudioPlayerManagerNotification:self];
}
@end
