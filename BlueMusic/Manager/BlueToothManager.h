//
//  BlueToothManager.h
//  LED
//
//  Created by csxfno21 on 14-6-16.
//  Copyright (c) 2014年 com.company.sxb. All rights reserved.
//



#define CALL_ENABLE_OPEN             0x00
#define CALL_ENABLE_CLOSE            0x00
#define CALL_SCAN_START              0x00
#define CALL_APP_EXIT                0x00

#define RES_PHONE_START              0x00
#define RES_PHONE_END                0x00


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueToothDelegate.h"
#import "PeripheralEntity.h"
@interface BlueToothManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager *centralManager;   //中心角色
    
    NSMutableArray *bleNotifications;
    
    int lastTime;

}
@property(readonly,strong,nonatomic)NSMutableArray *foundPeripheralArray;
+ (BlueToothManager*)sharedInstanced;

- (PeripheralEntity*)getPeripheralentity;

- (void) refushDevice;
- (void) connectPeripheral:(CBPeripheral*)peripheral;

- (void)addCache2local:(id)data withKey:(id)key;
- (id)loadLocalCache:(id)key;
//注册观察者
- (void)registerBleManagerNotification:(id<BlueToothManagerDelegate>)delegate;
//注销观察者
- (void)unRegisterBleManagerNotification:(id<BlueToothManagerDelegate>)delegate;


#pragma mark - Source change request 0x80
/*!
 *  @author csxfno21, 15-03-01 00:03:58
 *
 *  @brief  请求打开TF卡
 *
 *  @since 1.0
 */
- (void)requestMusicTF;

/*!
 *  @author csxfno21, 15-03-01 01:03:38
 *
 *  @brief  请求蓝牙音乐打开
 *
 *  @since 1.0
 */
- (void)requestMusicBLE;

#pragma mark - function setup change 0x81
/*!
 *  @author csxfno21, 15-04-01 08:04:55
 *
 *  @brief  开启负离子功能开关
 *
 *  @since 1.0
 */
- (void)requestAnionOn;

/*!
 *  @author csxfno21, 15-04-01 08:04:02
 *
 *  @brief  关闭负离子功能开关
 *
 *  @since 1.0
 */
- (void)requestAnionOff;

/*!
 *  @author csxfno21, 15-04-01 08:04:32
 *
 *  @brief  开启蓝牙免提功能开关
 *
 *  @since 1.0
 */
- (void)requestBlutoothOn;

/*!
 *  @author csxfno21, 15-04-01 08:04:42
 *
 *  @brief  关闭蓝牙免提功能
 *
 *  @since 1.0
 */
- (void)requestBlutoothOff;

/*!
 *  @author csxfno21, 15-04-01 08:04:12
 *
 *  @brief  开启musicAir功能
 *
 *  @since 1.0
 */
- (void)requestMusicAirOn;

/*!
 *  @author csxfno21, 15-04-01 08:04:42
 *
 *  @brief  关闭musicAir功能
 *
 *  @since 1.0
 */
- (void)requestMusicAirOff;

/*!
 *  @author csxfno21, 15-04-01 08:04:17
 *
 *  @brief  空气质量自动开启净化功能
 *
 *  @since 1.0
 */
- (void)requestAirqualityOn;

/*!
 *  @author csxfno21, 15-04-01 08:04:10
 *
 *  @brief  空气质量自动关闭净化功能
 *
 *  @since 1.0
 */
- (void)requestAirqualityOff;


#pragma mark - music 0x82
/*!
 *  @author csxfno21, 15-03-01 09:03:10
 *
 *  @brief  单曲循环
 *
 *  @since 1.0
 */
- (void)requestRepeat;

/*!
 *  @author csxfno21, 15-03-01 09:03:31
 *
 *  @brief  上一首
 *
 *  @since 1.0
 */
- (void)requestPrev;

/*!
 *  @author csxfno21, 15-03-01 09:03:53
 *
 *  @brief  下一首
 *
 *  @since 1.0
 */
- (void)requestNext;

/*!
 *  @author csxfno21, 15-03-01 09:03:29
 *
 *  @brief  播放或者
 *
 *  @since 1.0
 */
- (void)requestPlayOrPause;

/*!
 *  @author csxfno21, 15-03-01 09:03:47
 *
 *  @brief  随机播放
 *
 *  @since 1.0
 */
- (void)requestRandom;


#pragma mark -Air Purify Mode Change 0x83
/*!
 *  @author csxfno21, 15-04-01 09:04:02
 *
 *  @brief  静音模式
 *
 *  @since 1.0
 */
- (void)requestSilenceMode;

/*!
 *  @author csxfno21, 15-04-01 09:04:13
 *
 *  @brief  超级净化模式
 *
 *  @since 1.0
 */
- (void)requestSuperPurifyMode;

/*!
 *  @author csxfno21, 15-04-01 09:04:42
 *
 *  @brief  普通模式
 *
 *  @since 1.0
 */
- (void)requestNormalMode;


#pragma mark - App connect Request 0x84
/*!
 *  @author csxfno21, 15-03-01 09:03:07
 *
 *  @brief  发送连接指令
 *
 *  @since 1.0
 */
- (void)requestConnet;

/*!
 *  @author csxfno21, 15-03-01 09:03:30
 *
 *  @brief  发送退出指令
 *
 *  @since 1.0
 */
- (void)requestLogout;


#pragma mark - 闹铃 0x85
/*!
 *  @author csxfno21, 15-03-01 09:03:12
 *
 *  @brief  时间校对
 *
 *  @since 1.0
 */
- (void)requestCheckClockTime;


#pragma mark - Clock Setup 0x86
/*!
 *  @author csxfno21, 15-03-01 09:03:25
 *
 *  @brief  设置一个闹钟
 *
 *  @since 1.0
 */
- (void)requestAddClock:(NSInteger)index
               withHour:(NSInteger)hour
             withMinute:(NSInteger)minute
          withVoiceType:(NSInteger)voiceType
           withWorkTime:(NSInteger)workTime;

/*!
 *  @author csxfno21, 15-03-01 09:03:49
 *
 *  @brief  关闭一个闹钟
 *
 *  @since 1.0
 */
- (void)requestCloseClock;


#pragma mark - Select Song Request 0x87

/*!
 *  @author csxfno21, 15-04-01 09:04:19
 *
 *  @brief  发送请求某一首歌曲
 *  @pramater index 序列号
 *
 *  @since 1.0
 */
- (void)requestSelectSong:(int)index;

#pragma mark - Audio Setup Change 0x88
/*!
 *  @author csxfno21, 15-03-01 09:03:48
 *
 *  @brief  强劲模式、增强低音开关
 *
 *  @since 1.0
 */
- (void)requestAudioStepChange:(NSString *)data1 withData2:(NSString *)data2;

#pragma mark -function setup request 0x89

/*!
 *  @author csxfno21, 15-04-01 09:04:13
 *
 *  @brief  请求进入设置页面
 *
 *  @since 1.0
 */
- (void)requestSetting;


#pragma mark - Environmental Request 0x8A
/*!
 *  @author csxfno21, 15-04-01 09:04:39
 *
 *  @brief  请求进入环境展示页面
 *
 *  @since 1.0
 */
- (void)requestEnvironmentShow;


#pragma mark - Clock Request 0x8B
/*!
 *  @author csxfno21, 15-03-01 09:03:03
 *
 *  @brief  请求闹钟设置页面
 *
 *  @since 1.0
 */
- (void)requestClockSetting;


#pragma mark - AudioSetup 0x8C
/*!
 *  @author csxfno21, 15-03-01 09:03:15
 *
 *  @brief  请求音效设置页面
 *
 *  @since 1.0
 */
- (void)requestAudioStepSetting;


#pragma mark - Air/空气 0x8D
/*!
 *  @author csxfno21, 15-03-01 09:03:59
 *
 *  @brief  进入空气设置页面
 *
 *  @since 1.0
 */
- (void)requestAIRSetting;


#pragma mark - ACK  NACK
/*!
 *  @author csxfno21, 15-04-03 11:04:54
 *
 *  @brief  发送ACK
 *
 *  @since 1.0
 */
- (void)requestACK;

- (void)requestNACK;
@end
