//
//  BlueAudioPlayerManager.m
//  BlueMusic
//
//  Created by company on 15-4-3.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BlueAudioPlayerManager.h"

@interface BlueAudioPlayerManager ()
{
    int currentSeconds;
    int totalSeconds;
    NSTimer *timer;
    BOOL    isRepeat;
    BOOL    isPause;
    BOOL    isRandom;
}
@end

@implementation BlueAudioPlayerManager

+ (BlueAudioPlayerManager *)sharedInstanced
{
    static BlueAudioPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager)
        {
            manager = [[BlueAudioPlayerManager alloc] init];
        }
    });
    return manager;
}

-(instancetype)init
{
    if ((self = [super self]))
    {
        _currentIndex = -1;
        isRepeat = NO;
        isPause = NO;
        isRandom = NO;
        _list = [self getMusicList];
        audioNotifications = [NSMutableArray array];
    }
    return self;
}

//注册观察者
- (void)registerBleAudioPlayerManagerNotification:(id<BlueAudioPlayerDelegate>)delegate
{
    if (![audioNotifications containsObject:delegate])
    {
        [audioNotifications addObject:delegate];
    }
}
//注销观察者
- (void)unRegisterBleAudioPlayerManagerNotification:(id<BlueAudioPlayerDelegate>)delegate
{
    if ([audioNotifications containsObject:delegate])
    {
        [audioNotifications removeObject:delegate];
    }
}

/*!
 *  @author csxfno21, 15-04-03 10:04:24
 *
 *  @brief  获取手机音乐列表
 *
 *  @since 1.0
 */
- (NSArray *)getMusicList
{
    MPMediaQuery *myPlaylistQuery = [[MPMediaQuery alloc] init];
    return [myPlaylistQuery items];
}

/*!
 *  @author csxfno21, 15-04-03 09:04:10
 *
 *  @brief  播放选中的歌曲
 *
 *  @param index 选中的序号
 *
 *  @since 1.0
 */
-(void)playWithIndex:(int)index
{
    _currentIndex = index;
    [self setAndPlay:_currentIndex];
}

/*!
 *  @author csxfno21, 15-04-03 09:04:07
 *
 *  @brief  重复播放
 *
 *  @since 1.0
 */
- (void)repeate
{
    isRepeat = YES;
    isRandom = NO;
}

/*!
 *  @author csxfno21, 15-04-03 09:04:33
 *
 *  @brief  暂停和播放
 *
 *  @since 1.0
 */
-(void)playOrPause
{
    if (isPause)
    {
        isPause = NO;
        [audioPlayer play];
    }
    else
    {
        isPause = YES;
        [audioPlayer pause];
    }
}

/*!
 *  @author csxfno21, 15-04-03 09:04:08
 *
 *  @brief  播放前一首
 *
 *  @since 1。0
 */
-(void)playPre
{
    int i = 0;
    if (_currentIndex == -1 || _currentIndex == 0)
    {
        i = _list.count - 1;
    }
    else
    {
        i = _currentIndex - 1;
    }
    [self setAndPlay:i];
}

/*!
 *  @author csxfno21, 15-04-03 09:04:23
 *
 *  @brief  播放下一首
 *
 *  @since 1.0
 */
-(void)playNext
{
    int i = 0;
    if (_currentIndex == _list.count - 1)
    {
        i = 0;
    }
    else
    {
        i = _currentIndex + 1;
    }
    [self setAndPlay:i];
}

/*!
 *  @author csxfno21, 15-04-03 09:04:51
 *
 *  @brief  随机播放
 *
 *  @since 1.0
 */
-(void)playRandom
{
    isRepeat = NO;
    isRandom = YES;
}

/*!
 *  @author csxfno21, 15-04-03 11:04:45
 *
 *  @brief  手动调节音乐进度
 *
 *  @since 1.0
 */
- (void)musicProgressChanged:(float)value
{
    [timer invalidate];
    timer = nil;
    MPMediaItem *song = [self.list objectAtIndex:_currentIndex];
    currentSeconds = value * song.playbackDuration;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    audioPlayer.currentTime = currentSeconds;
}

/*!
 *  @author csxfno21, 15-04-03 10:04:07
 *
 *  @brief  设置和播放
 *
 *  @param index 播放序号
 *
 *  @since 1.0
 */
- (void)setAndPlay:(int)index
{
    [timer invalidate];
    timer = nil;
    MPMediaItem *song = [self.list objectAtIndex:index];
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [audioPlayer setDelegate:self];
    [audioPlayer play];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    currentSeconds = 0;
    totalSeconds = song.playbackDuration;
    NSString *totalTime = [self getMinAndSec:song.playbackDuration];
    
    for (id<BlueAudioPlayerDelegate> delegate in audioNotifications)
    {
        if (delegate && [delegate respondsToSelector:@selector(BlueAudioPlayerManager:withTotalTime:)])
        {
            [delegate BlueAudioPlayerManager:self withTotalTime:totalTime];
        }
    }
}


- (void)timerFired:(id)sender
{
    currentSeconds = currentSeconds + 1;
    NSString *currentTime = [self getMinAndSec:currentSeconds];
    float progress = (float)currentSeconds / totalSeconds;
    for (id<BlueAudioPlayerDelegate> delegate in audioNotifications)
    {
        if (delegate && [delegate respondsToSelector:@selector(BlueAudioPlayerManager:withCurrentTime:)])
        {
            [delegate BlueAudioPlayerManager:self withCurrentTime:currentTime];
        }
        if (delegate && [delegate respondsToSelector:@selector(BlueAudioPlayerManager:withProgress:)])
        {
            [delegate BlueAudioPlayerManager:self withProgress:progress];
        }
    }
}

//根据秒获取 分钟和秒
- (NSString *)getMinAndSec:(int)secondes
{
    int min = secondes / 60;
    int sec = secondes % 60;
    NSString *minStr,*secStr;
    if (sec < 10)
    {
        secStr = [NSString stringWithFormat:@"0%d",sec];
    }
    else
    {
        secStr = [NSString stringWithFormat:@"%d",sec];
    }
    
    if (min < 10)
    {
        minStr = [NSString stringWithFormat:@"0%d",min];
    }
    else
    {
        minStr = [NSString stringWithFormat:@"%d",min];
    }
    NSString *str = [NSString stringWithFormat:@"%@:%@",minStr,secStr];
    return str;
}

#pragma mark - AVAudioPlayer delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [timer invalidate];
    timer = nil;
    if (isRepeat && !isRandom) //单曲循环
    {
        
    }
    else
    {
        if (!isRepeat && isRandom)  //随机播放
        {
            _currentIndex = arc4random() % _list.count;
        }
        else    //顺序播放
        {
            if (_currentIndex < _list.count - 1)
            {
                _currentIndex ++;
            }
            else
            {
                _currentIndex = 0;
            }
        }
    }
    
    if (_list && _list.count > 0)
    {
        [self setAndPlay:_currentIndex];
    }
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [audioPlayer play];
}

@end
