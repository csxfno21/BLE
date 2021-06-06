//
//  BlueAudioPlayerManager.h
//  BlueMusic
//
//  Created by company on 15-4-3.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class BlueAudioPlayerManager;
@protocol BlueAudioPlayerDelegate <NSObject>

- (void)BlueAudioPlayerManager:(BlueAudioPlayerManager*)manager withTotalTime:(NSString *)totalTime;

- (void)BlueAudioPlayerManager:(BlueAudioPlayerManager *)manager withCurrentTime:(NSString *)currentTime;

-(void)BlueAudioPlayerManager:(BlueAudioPlayerManager *)manager withProgress:(float)progress;
@end

@interface BlueAudioPlayerManager : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
    NSMutableArray *audioNotifications;
}
@property (nonatomic, strong, readonly)NSArray *list;
@property (nonatomic, assign, readonly)int      currentIndex;

+(BlueAudioPlayerManager *)sharedInstanced;

//注册观察者
- (void)registerBleAudioPlayerManagerNotification:(id<BlueAudioPlayerDelegate>)delegate;
//注销观察者
- (void)unRegisterBleAudioPlayerManagerNotification:(id<BlueAudioPlayerDelegate>)delegate;

/*!
 *  @author csxfno21, 15-04-03 10:04:24
 *
 *  @brief  获取手机音乐列表
 *
 *  @since 1.0
 */
- (NSArray *)getMusicList;

/*!
 *  @author csxfno21, 15-04-03 09:04:10
 *
 *  @brief  播放选中的歌曲
 *
 *  @param index 选中的序号
 *
 *  @since 1.0
 */
- (void)playWithIndex:(int)index;

/*!
 *  @author csxfno21, 15-04-03 09:04:07
 *
 *  @brief  重复播放
 *
 *  @since 1.0
 */
- (void)repeate;

/*!
 *  @author csxfno21, 15-04-03 09:04:33
 *
 *  @brief  暂停和播放
 *
 *  @since 1.0
 */
- (void)playOrPause;

/*!
 *  @author csxfno21, 15-04-03 09:04:08
 *
 *  @brief  播放前一首
 *
 *  @since 1。0
 */
- (void)playPre;

/*!
 *  @author csxfno21, 15-04-03 09:04:23
 *
 *  @brief  播放下一首
 *
 *  @since 1.0
 */
- (void)playNext;

/*!
 *  @author csxfno21, 15-04-03 09:04:51
 *
 *  @brief  随机播放
 *
 *  @since 1.0
 */
- (void)playRandom;

/*!
 *  @author csxfno21, 15-04-03 11:04:45
 *
 *  @brief  手动调节音乐进度
 *
 *  @since 1.0
 */
- (void)musicProgressChanged:(float)value;
@end
