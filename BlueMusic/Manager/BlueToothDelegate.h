//
//  BlueToothDelegate.h
//  LED
//
//  Created by csxfno21 on 14-6-17.
//  Copyright (c) 2014年 com.company.sxb. All rights reserved.
//


#define HEART_RATE_MEASUREMENT              @"0000000000000"
#define CLIENT_CHARACTERISTIC_CONFIG        @"0000000000000"
#define ISSC_SERVICE_UUID                   @"0000000000000"
#define ISSC_CHAR_RX_UUID                   @"0000000000000"
#define ISSC_CHAR_TX_UUID                   @"0000000000000"
#define ISSC_CHAR_TX_UUID1                  @"0000000000000"
#define ISSC_CHAR_TX_UUID2                  @"0000000000000"
#define ISSC_CHAR_TX_UUID3                  @"0000000000000"
#define ISSC_SERVICE_BATTERY                @"0000000000000"
#define ISSC_CHAR_BATTERY                   @"0000000000000"


typedef enum
{
    StatePoweredOff = 0,            //断电
    StateUnauthorized,              //未授权
    StateUnknown,                   //未知
    StateUnsupported,               //不支持
    StatePoweredOn,                 //上电
    StateResetting,                 //重置
    
}BLUE_TOOTH_STATE;

@class PeripheralEntity;
//@class DeviceEntity;
@protocol BlueToothManagerDelegate <NSObject>

@optional
- (void)bleManager:(id)manager stateChange:(BLUE_TOOTH_STATE)state;                     //状态切换
- (void)bleManager:(id)manager didDiscover:(NSArray*)foundPeripheralArray;              //扫瞄到设备
- (void)bleManager:(id)manager didConnected:(PeripheralEntity*)peripheralEntity;        //连接成功，可以发数据
- (void)bleManager:(id)manager didConnectFailed:(PeripheralEntity*)peripheralEntity;    //连接失败
- (void)bleManager:(id)manager didDisConnect:(PeripheralEntity*)peripheralEntity;       //断开连接
- (void)bleManagerStoped;                                                               //蓝牙断开了


//是否可以push tf
- (void)bleManager:(id)manager didCanPushTF:(BOOL)canPush;

//是否可以push蓝牙
- (void)bleManager:(id)manager didCanPushBle:(BOOL)canPush;


//信号更新了
//- (void)bleManager:(id)manager didUpdateSigle:(DeviceEntity*)device;


@end



