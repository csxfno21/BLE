//
//  BlueToothManager.m
//  FDQ
//
//  Created by csxfno21 on 14-12-16.
//  Copyright (c) 2014年 com.company.sxb. All rights reserved.
//

#import "BlueToothManager.h"
#import <UIKit/UIKit.h>
#import "UIToast.h"
#import "yk_bytes.h"

#define ReplaceNULL2Empty(str)   ((nil == (str)) ? @"" : (str))
static BlueToothManager *manager;
static int packageIDS = 0xFF;

@interface BlueToothManager ()
{
    //function setup change 实现
    int bit0;
    int bit1;
    int bit2;
    int bit4;
    int bit5;
    //预留功能，不用实现
    int bit3;
    int bit6;
    int bit7;
}
@end

@implementation BlueToothManager

- (id)init
{
    if (self = [super init])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            
        }
        
        bleNotifications = [[NSMutableArray alloc] init];
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        
        _foundPeripheralArray = [[NSMutableArray alloc] init];
        
        bit0 = 0;
        bit1 = 0;
        bit2 = 0;
        bit4 = 0;
        bit5 = 0;
        
        bit3 = 0;
        bit6 = 0;
        bit7 = 0;
    }
    return self;
}


//注册观察者
- (void)registerBleManagerNotification:(id<BlueToothManagerDelegate>)delegate
{
    if (![bleNotifications containsObject:delegate])
    {
        [bleNotifications addObject:delegate];
    }
}

//注销观察者
- (void)unRegisterBleManagerNotification:(id<BlueToothManagerDelegate>)delegate
{
    if ([bleNotifications containsObject:delegate])
    {
        [bleNotifications removeObject:delegate];
    }
}





#pragma mark - 连接超时
- (void)connectTimeout
{
    [self stopScanning];
    for (id<BlueToothManagerDelegate> delegate in bleNotifications)
    {
        if ([delegate respondsToSelector:@selector(bleManager:didDiscover:)])
        {
            [delegate bleManager:self didDiscover:_foundPeripheralArray];
        }
    }
}

#pragma mark - 开始扫瞄
// 按UUID进行扫描
- (void) startScanning
{
	NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:ISSC_SERVICE_UUID], nil];
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

- (void) stop
{
	[centralManager stopScan];
    [_foundPeripheralArray removeAllObjects];
    for (id<BlueToothManagerDelegate> delegate in bleNotifications)
    {
        if ([delegate respondsToSelector:@selector(bleManagerStoped)])
        {
            [delegate bleManagerStoped];
        }
    }
}
// 停止扫描
- (void) stopScanning
{
	[centralManager stopScan];
    [_foundPeripheralArray removeAllObjects];
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

#pragma mark - 重新扫描
- (void)rConnectPeripheral
{
	NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:ISSC_SERVICE_UUID], nil];
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

#pragma mark -  连接设备
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
	if ([peripheral state] == CBPeripheralStateDisconnected)
    {
        [centralManager connectPeripheral:peripheral options:nil];
	}
}

#pragma mark -  断开设备
- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    if ([peripheral state] == CBPeripheralStateConnected)
    {
        [centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOff:           //掉电状态
        {
            for (id<BlueToothManagerDelegate> delegate in bleNotifications)
            {
                if ([delegate respondsToSelector:@selector(bleManager:stateChange:)])
                {
                    [delegate bleManager:self stateChange:StatePoweredOff];
                }
            }
            
            [self stop];
//            [self startScanning];
            break;
        }
        case CBCentralManagerStateUnauthorized:         //未授权
        {
            for (id<BlueToothManagerDelegate> delegate in bleNotifications)
            {
                if ([delegate respondsToSelector:@selector(bleManager:stateChange:)])
                {
                    [delegate bleManager:self stateChange:StateUnauthorized];
                }
            }
            break;
        }
        case CBCentralManagerStateUnknown:              //未知状态
        {
            for (id<BlueToothManagerDelegate> delegate in bleNotifications)
            {
                if ([delegate respondsToSelector:@selector(bleManager:stateChange:)])
                {
                    [delegate bleManager:self stateChange:StateUnknown];
                }
            }
            break;
        }
        case CBCentralManagerStateUnsupported:          //不支持
        {
            for (id<BlueToothManagerDelegate> delegate in bleNotifications)
            {
                if ([delegate respondsToSelector:@selector(bleManager:stateChange:)])
                {
                    [delegate bleManager:self stateChange:StateUnsupported];
                }
            }
            break;
        }
        case CBCentralManagerStatePoweredOn:           //上电状态
        {
            for (id<BlueToothManagerDelegate> delegate in bleNotifications)
            {
                if ([delegate respondsToSelector:@selector(bleManager:stateChange:)])
                {
                    [delegate bleManager:self stateChange:StatePoweredOn];
                }
            }
            
            [self startScanning];
            break;
        }
        case CBCentralManagerStateResetting:           //重置状态
        {
            for (id<BlueToothManagerDelegate> delegate in bleNotifications)
            {
                if ([delegate respondsToSelector:@selector(bleManager:stateChange:)])
                {
                    [delegate bleManager:self stateChange:StateResetting];
                }
            }
            [self stopScanning];
            [self startScanning];
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - 重现扫瞄
- (void)refushDevice
{
    [_foundPeripheralArray removeAllObjects];
    [self stopScanning];
    [self startScanning];
}


#pragma mark - 扫瞄到设备

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    @synchronized(_foundPeripheralArray)
    {
        Byte rssi = -[RSSI unsignedCharValue];
        NSLog(@"peripheral:%@ RSSI:%d", peripheral.identifier, rssi);
        PeripheralEntity *entity = [[PeripheralEntity alloc] init];
        entity.deviceName = ReplaceNULL2Empty(peripheral.name);
        entity.peripheral = peripheral;
        for (PeripheralEntity *perEntity in _foundPeripheralArray)
        {
            if ([perEntity.peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString])
            {
                return;
            }
        }
        [_foundPeripheralArray addObject:entity];
        
        //扫描到了设备
        for (id<BlueToothManagerDelegate> delegate in bleNotifications)
        {
            if ([delegate respondsToSelector:@selector(bleManager:didDiscover:)])
            {
                [delegate bleManager:self didDiscover:_foundPeripheralArray];
            }
        }
        
//        for (DeviceEntity *device in _deviceEntityArray)
        {
//            if ([device.UUID isEqualToString:entity.peripheral.identifier.UUIDString])
            {
                [self connectPeripheral:entity.peripheral];
//                break;
            }
            
        }
    
    }
    
}



#pragma mark - 连接到设备
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    CBUUID  *LEDSerUUID   = [CBUUID UUIDWithString:ISSC_SERVICE_UUID];
    NSArray	*serviceArray = [NSArray arrayWithObjects: LEDSerUUID, nil];
    peripheral.delegate = self;
    [peripheral discoverServices:serviceArray];
    [[[UIToast alloc] init] show:@"发现设备"];
}
// 中心设备连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接外围设备 %@ 失败出错",peripheral.name);
    PeripheralEntity *p = [self peripheral:peripheral];
    if (!p)
    {
        NSLog(@"错误,未找到存储设备");
        return;
    }
    
    for (id<BlueToothManagerDelegate> delegate in bleNotifications)
    {
        if ([delegate respondsToSelector:@selector(bleManager:didConnectFailed:)])
        {
            [delegate bleManager:self didConnectFailed:p];
        }
    }
    
    [self stop];
//    [self startScanning];
//    [self connectPeripheral:p.peripheral];
    [self rConnectPeripheral];
}

// 中心设备断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{

    NSLog(@"断开外围设备 %ld",(long)error.code);
    [[[UIToast alloc] init] show:@"设备断开"];
    PeripheralEntity *p = [self peripheral:peripheral];
    if (p)
    {
        [_foundPeripheralArray removeObject:p];
    }
    else
    {
        NSLog(@"错误,未找到存储设备");
        return;
    }

    for (id<BlueToothManagerDelegate> delegate in bleNotifications)
    {
        if ([delegate respondsToSelector:@selector(bleManager:didDisConnect:)])
        {
            [delegate bleManager:self didDisConnect:p];
        }
    }
//    [self stop];
//    [self connectPeripheral:peripheral];
//    [self rConnectPeripheral];
    [self stopScanning];
    [self startScanning];
}
#pragma mark - 扫瞄服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        // 错误
        
        return;
    }
    
    NSArray *services = [peripheral services];
    
    if (!services || ![services count])
    {
        NSLog(@"发现错误的服务 %@", peripheral.services);
        return;
    }
    
    for (CBService *services in peripheral.services)
    {
        if ([[services UUID] isEqual:[CBUUID UUIDWithString:ISSC_SERVICE_UUID]])
        {
            // 扫描服务特征值UUID
            [peripheral discoverCharacteristics:nil forService:services];
          
        }
    }
    
}

#pragma mark - 扫瞄特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        //错误
        return;
    }
    
    NSArray *characteristics = [service characteristics];
    if (!characteristics || ![characteristics count])
    {
        NSLog(@"发现错误的特征 %@", service.characteristics);
        return;
    }
    PeripheralEntity *p = [self peripheral:peripheral];
    if (!p)
    {
        NSLog(@"错误,未找到存储设备");
        return;
    }
    if ([[service UUID] isEqual:[CBUUID UUIDWithString:ISSC_SERVICE_UUID]])
    {
        for (CBCharacteristic *characteristic in characteristics)
        {
            NSLog(@"发现特值UUID: %@", [characteristic UUID]);
            
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
            if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:ISSC_CHAR_RX_UUID]])
            {
                p.Characteristic0 = characteristic;
            }
            else if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:ISSC_CHAR_TX_UUID]])
            {
                p.Characteristic1 = characteristic;
            }
            if (p.Characteristic0 && p.Characteristic1)
            {
                [[[UIToast alloc] init] show:@"连接成功,正在发送配对指令"];
                [self requestConnet];
                for (id<BlueToothManagerDelegate> delegate in bleNotifications)
                {
                    if ([delegate respondsToSelector:@selector(bleManager:didConnected:)])
                    {
                        [delegate bleManager:self didConnected:p];
                    }
                }
            }
        }
    }
    
}


// 写数据到特征值
-(void) writeValue:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic data:(NSData *)data
{
    if (!peripheral)
    {
        NSLog(@"Not connected to a peripheral with UUID %@ to writeValue\n", peripheral);
        return;
    }
    else
    {
        if (!characteristic)
        {
            NSLog(@"Could not find characteristic with UUID %@ on peripheral with UUID %@ to writeValue\n", characteristic, peripheral);
        }
        else
        {
            
            [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    if (data && data.length > 0)
    {
        Byte *bytes = (Byte *)[data bytes];
        //Temperature and humidity Info
        char TAHI_ID = 0x00;
        char TAHI_length = 0x00;
        //一些开关
        char FSI_ID = 0x00;
        char FSI_LENGTH = 0x00;
        //TF播放状态
        char MPEG_ID = 0x00;
        char MPEG_LENGHT = 0x00;
        //闹钟
        char CLOCK_ID = 0x08;
        char CLOCK_LENGTH = 0x00;
        if (TAHI_ID == bytes[2])
        {
            //温度、湿度、pm2.5
            if(TAHI_length == bytes[3])
            {
                //长度对的
                //温度
                int temperature = bytes[4];
                //湿度
                int humidity = bytes[5];
                //VOC
                int VOCS = bytes[6];
                int VOCE = bytes[7];
                //PM2.5
                int PMS = bytes[8];
                int PME = bytes[9];
                
                [[[UIToast alloc] init] show:[NSString stringWithFormat:@"接收到温度:%d 湿度:%d VOC:%d.%d PM2.5数:%d.%d",temperature,humidity,VOCS,VOCE,PMS,PME]];
            }
        }
        else if(FSI_ID == bytes[2])
        {
            //是否开启关闭了呼吸灯、负离子、蓝牙免提电话、music air、自动净化器
            if (FSI_LENGTH == bytes[3])
            {
                [[[UIToast alloc] init] show:@"是否开启关闭了呼吸灯、负离子、蓝牙免提电话、music air、自动净化器"];
            }
        }
        else if (CLOCK_ID == bytes[2])
        {
            if(CLOCK_LENGTH == bytes[3])
            {
                [[[UIToast alloc] init] show:@"闹钟"];
            }
        }
        
        
//        for(int i=0;i<[data length];i++)
//        {
//            printf("testByte = %2x\n",bytes[i]);
//        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *data = characteristic.value;
    if (data && data.length > 0)
    {
        Byte *bytes = (Byte *)[data bytes];
        //Temperature and humidity Info
        char TAHI_ID = 0x00;
        char TAHI_length = 0x00;
        //一些开关
        char FSI_ID = 0x00;
        char FSI_LENGTH = 0x00;
        //TF播放状态
        char MPEG_ID = 0x00;
        char MPEG_LENGHT = 0x00;
        //闹钟
        char CLOCK_ID = 0x00;
        char CLOCK_LENGTH = 0x00;
        
        if (CLOCK_ID == bytes[2])
        {
            if(CLOCK_LENGTH == bytes[3])
            {
                [[[UIToast alloc] init] show:@"闹钟"];
            }
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
//    NSLog(@"[CBController] didWriteValueForCharacteristic error msg:%d, %@, %@", error.code ,[error localizedFailureReason], [error localizedDescription]);
//    NSLog(@"characteristic data = %@ id = %@",characteristic.value,characteristic.UUID);
//    
//    if (error)
//    {
//        [[[UIToast alloc] init] show:[NSString stringWithFormat:@"发送指令失败:%@",error.userInfo]];
//        NSLog(@"=======%@",error.userInfo);
//    }
//    else
//    {
//        NSLog(@"发送数据成功");
//        [[[UIToast alloc] init] show:@"发送指令成功成功"];
//    }

    NSData *data = characteristic.value;
    if (data && data.length > 0)
    {
        Byte *bytes = (Byte *)[data bytes];
        //Temperature and humidity Info
        char TAHI_ID = 0x00;
        char TAHI_length = 0x00;
        //一些开关
        char FSI_ID = 0x00;
        char FSI_LENGTH = 0x00;
        //TF播放状态
        char MPEG_ID = 0x00;
        char MPEG_LENGHT = 0x00;
        //闹钟
        char CLOCK_ID = 0x00;
        char CLOCK_LENGTH = 0x00;
        
        if (CLOCK_ID == bytes[2])
        {
            if(CLOCK_LENGTH == bytes[3])
            {
                [[[UIToast alloc] init] show:@"闹钟"];
            }
        }
    }
    
}
// 从特征值读取数据
-(void) readValue:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic
{
    if (!peripheral)
    {
        NSLog(@"Not connected to a peripheral with UUID %@ to readValue\n", peripheral);
        return;
    }
    else
    {
        if (!characteristic) {
            NSLog(@"Could not find characteristic with UUID %@ on peripheral with UUID %@ to readValue\n", characteristic, peripheral);
        }
        else
        {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

// 发通知到特征值
-(void) notification:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic state:(BOOL)state
{
    if (!peripheral)
    {
        NSLog(@"Not connected to a peripheral with UUID %@ to notification\n", peripheral);
        return;
    }
    else
    {
        if (!characteristic) {
            NSLog(@"Could not find characteristic with UUID %@ on peripheral with UUID %@ to notification\n", characteristic, peripheral);
        }
        else
        {
            //NSLog(@"成功发通知到特征值: %@\n", characteristic);
            [peripheral setNotifyValue:state forCharacteristic:characteristic];
        }
    }
}






- (PeripheralEntity*)peripheral:(CBPeripheral*)p
{
    for (PeripheralEntity * per in _foundPeripheralArray)
    {
        if ([per.peripheral.identifier.UUIDString isEqualToString:p.identifier.UUIDString])
        {
            return per;
        }
    }
    
    return nil;
}


/**********************************************************
 函数名称：- (void)addCache2local:(id)data withKey:(id)key
 函数描述：保存缓存
 输入参数：data 内容   key 标签
 输出参数：N/A
 返回值：N/A
 创建人：yandaoqiu
 修改备注：N/A
 **********************************************************/
- (void)addCache2local:(id)data withKey:(id)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:data];
    [userDefaults setObject:udObject forKey:key];
}

/**********************************************************
 函数名称：- (id)loadLocalCache:(id)key
 函数描述：读取缓存
 输入参数：key 标签
 输出参数：N/A
 返回值：N/A
 创建人：yandaoqiu
 修改备注：N/A
 **********************************************************/
- (id)loadLocalCache:(id)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id unObject = [userDefaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:unObject];
}

/**************************************************开始写数据**********************************************************************/

- (PeripheralEntity *)getPeripheralentity
{
    return [_foundPeripheralArray firstObject];
}

//十六进制字母转为十进制值
- (int)toByte:(char)ch
{
    NSString* strCh = [NSString stringWithFormat:@"%c", ch];
    NSRange range = [@"0123456789ABCDEF" rangeOfString:strCh];
    return range.location;
}

- (NSData*)hexStringToBytes:(NSString*)hexString
{
    hexString = [hexString uppercaseString];
    
    Yk_Bytes bytes([hexString length] / 2);
    Yk_Bytes hexBytes([hexString length], [hexString UTF8String]);
    for(int i = 0; i < [hexString length] / 2; i++)
    {
        char byteTemp = (char)(([self toByte:hexBytes[i*2] ] << 4) | [self toByte:hexBytes[i*2+1] ]);
        bytes[i] = byteTemp;
    }
    NSData* data = [NSData dataWithBytes:bytes.GetBuffer() length:bytes.length()];
    return data;
}

//16进制加法
- (int)hexAddOne
{
    if (packageIDS == 255)
    {
        return packageIDS = 0x01;
    }
    else
        return packageIDS + 1;
}

/**
 *  @author wangshuai
 *
 *  @brief  10进制数转换为16进制的字符串
 *
 *  @return 16进制字符串
 *
 *  @since 1.0
 */
- (NSString *)hexToString
{
    int i = [self hexAddOne];
    return [self hexToString:i];
}

- (NSString *)hexToString :(unsigned long)c
{
    NSString *hexStr = nil;
    unsigned long i = c;
    unsigned long a = i / 16; //商
    unsigned long b = i % 16; //余数
    NSString *a1 = nil;
    NSString *b1 = nil;
    if (a > 9 && a < 16)
    {
        if (a == 10)
        {
            a1 = @"A";
        }
        else if (a == 11)
        {
            a1 = @"B";
        }
        else if (a == 12)
        {
            a1 = @"C";
        }
        if (a == 13)
        {
            a1 = @"D";
        }
        else if (a == 14)
        {
            a1 = @"E";
        }
        else if (a == 15)
        {
            a1 = @"F";
        }
    }
    if (b > 9 && b < 16)
    {
        if (b == 10)
        {
            b1 = @"A";
        }
        else if (b == 11)
        {
            b1 = @"B";
        }
        else if (b == 12)
        {
            b1 = @"C";
        }
        if (b == 13)
        {
            b1 = @"D";
        }
        else if (b == 14)
        {
            b1 = @"E";
        }
        else if (b == 15)
        {
            b1 = @"F";
        }
    }
    if (a > 9 && b > 9)
    {
        hexStr = [NSString stringWithFormat:@"%@%@",a1,b1];
    }
    else if (a > 9 && b <= 9)
    {
        hexStr = [NSString stringWithFormat:@"%@%lu",a1,b];
    }
    else if (a <= 9 && b > 9)
    {
        hexStr = [NSString stringWithFormat:@"%lu%@",a,b1];
    }
    else
    {
        hexStr = [NSString stringWithFormat:@"%lu%lu",a,b];
    }
    
    return hexStr;
}

#pragma mark - Source change request 0x80
#pragma mark - 请求打开TF卡页面
- (void)requestMusicTF
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@800100%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 请求打开蓝牙
- (void)requestMusicBLE
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@800101%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - function setup change 0x81
#pragma mark - 开启负离子功能开关
- (void)requestAnionOn
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        int s = 16;
        bit4 = s;
        int sum = bit0 + bit1 + bit2 + bit3 + bit4 + bit5 + bit6 + bit7;
        NSString *str = [self hexToString:sum];
        unsigned long hexPara = strtoul([str UTF8String], 0, 16);
        unsigned long a = 0x00^0x00^hexPara;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8001%@%@AA",hexStr,str,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 关闭负离子功能开关
- (void)requestAnionOff
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        int s = 16;
        bit4 = s;
        int sum = bit0 + bit1 + bit2 + bit3 + bit4 + bit5 + bit6 + bit7;
        NSString *str = [self hexToString:sum];
        unsigned long hexPara = strtoul([str UTF8String], 0, 16);
        unsigned long a = 0x00^0x00^hexPara;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8001%@%@AA",hexStr,str,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 开启蓝牙免提功能开关
- (void)requestBlutoothOn
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        int s = 8;
        bit2 = s;
        int sum = bit0 + bit1 + bit2 + bit3 + bit4 + bit5 + bit6 + bit7;
        NSString *str = [self hexToString:sum];
        unsigned long hexPara = strtoul([str UTF8String], 0, 16);
        unsigned long a = 0x00^0x00^hexPara;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8001%@%@AA",hexStr,str,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 关闭蓝牙免提功能
- (void)requestBlutoothOff
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        int s = 0;
        bit2 = s;
        int sum = bit0 + bit1 + bit2 + bit3 + bit4 + bit5 + bit6 + bit7;
        NSString *str = [self hexToString:sum];
        unsigned long hexPara = strtoul([str UTF8String], 0, 16);
        unsigned long a = 0x00^0x00^hexPara;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8001%@%@AA",hexStr,str,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 开启musicAir功能
- (void)requestMusicAirOn
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        int s = 4;
        bit1 = s;
        int sum = bit0 + bit1 + bit2 + bit3 + bit4 + bit5 + bit6 + bit7;
        NSString *str = [self hexToString:sum];
        unsigned long hexPara = strtoul([str UTF8String], 0, 16);
        unsigned long a = 0x00^0x00^hexPara;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8001%@%@AA",hexStr,str,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 关闭musicAir功能
- (void)requestMusicAirOff
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        int s = 0;
        bit1 = s;
        int sum = bit0 + bit1 + bit2 + bit3 + bit4 + bit5 + bit6 + bit7;
        NSString *str = [self hexToString:sum];
        unsigned long hexPara = strtoul([str UTF8String], 0, 16);
        unsigned long a = 0x00^0x00^hexPara;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8001%@%@AA",hexStr,str,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 空气质量自动开启净化功能
- (void)requestAirqualityOn
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        int s = 1;
        bit0 = s;
        int sum = bit0 + bit1 + bit2 + bit3 + bit4 + bit5 + bit6 + bit7;
        NSString *str = [self hexToString:sum];
        unsigned long hexPara = strtoul([str UTF8String], 0, 16);
        unsigned long a = 0x00^0x00^hexPara;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8001%@%@AA",hexStr,str,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 空气质量自动关闭净化功能
- (void)requestAirqualityOff
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        int s = 0;
        bit0 = s;
        int sum = bit0 + bit1 + bit2 + bit3 + bit4 + bit5 + bit6 + bit7;
        NSString *str = [self hexToString:sum];
        unsigned long hexPara = strtoul([str UTF8String], 0, 16);
        unsigned long a = 0x00^0x00^hexPara;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8001%@%@AA",hexStr,str,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}


#pragma mark - music 0x82
#pragma mark - 单曲循环
- (void)requestRepeat
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@820120%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 上一首
- (void)requestPrev
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@820117%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 下一首
- (void)requestNext
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@820116%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 暂停或者播放
- (void)requestPlayOrPause
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@820102%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 随机播放
- (void)requestRandom
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@820121%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark -Air Purify Mode Change 0x83
#pragma mark - 静音模式
- (void)requestSilenceMode
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if(entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@820100%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 超级净化模式
- (void)requestSuperPurifyMode
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if(entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@820101%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 普通模式
- (void)requestNormalMode
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if(entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@820102%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}


#pragma mark - App connect Request 0x84
#pragma mark - 请求连接
- (void)requestConnet
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@840101%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
    
}

#pragma mark - 请求退出
- (void)requestLogout
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        unsigned long a = 0x00^0x00^0x00;
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@840102%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 闹铃   0x85
#pragma mark - 时间校对
- (void)requestCheckClockTime
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        //获取当前时间
        NSDate * senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HHmm"];
        NSString * locationString=[dateformatter stringFromDate:senddate];
        NSString *hexString0 = [[NSString alloc] initWithFormat:@"%02lx",(long)[locationString substringToIndex:2].integerValue];
        unsigned long c0 = strtoul([hexString0 UTF8String],0,16);
        
        NSString *hexString1 = [[NSString alloc] initWithFormat:@"%02lx",(long)[locationString substringFromIndex:2].integerValue];
        unsigned long c1 = strtoul([hexString1 UTF8String],0,16);
        
        unsigned long a = 0x85^c0^c1;
        NSString *zero = [self hexToString:c0];
        NSString *second = [self hexToString:c1];
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8502%@%@%@AA",hexStr,zero,second,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 添加一个闹铃 0x86
- (void)requestAddClock:(NSInteger)index
               withHour:(NSInteger)hour
             withMinute:(NSInteger)minute
          withVoiceType:(NSInteger)voiceType
           withWorkTime:(NSInteger)workTime
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        
        NSString *hexString0 = [[NSString alloc] initWithFormat:@"0x%02ld",(long)index];
        unsigned long c0 = strtoul([hexString0 UTF8String], 0, 16);
        
        NSString *hexString1 = [[NSString alloc] initWithFormat:@"0x%02lx",(long)hour];
        unsigned long c1 = strtoul([hexString1 UTF8String], 0, 16);
        
        NSString *hexString2 = [[NSString alloc] initWithFormat:@"0x%02lx",(long)minute];
        unsigned long c2 = strtoul([hexString2 UTF8String], 0, 16);
        
        NSString *hexString3 = [[NSString alloc] initWithFormat:@"0x%02lx",(long)voiceType];
        unsigned long c3 = strtoul([hexString3 UTF8String], 0, 16);
        
        NSString *hexString4 = [[NSString alloc] initWithFormat:@"0x%02lx",(long)workTime];
        unsigned long c4 = strtoul([hexString4 UTF8String], 0, 16);
        
        unsigned long a = 0x86^0x05^c0^c1^c2^c3^c4;
        NSString *zeor = [self hexToString:c0];
        NSString *first = [self hexToString:c1];
        NSString *second = [self hexToString:c2];
        NSString *third = [self hexToString:c3];
        NSString *fourth = [self hexToString:c4];
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8605%@%@%@%@%@%@AA",hexStr,zeor,first,second,third,fourth,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
    
}

#pragma makr - 关闭闹铃
- (void)requestCloseClock
{
    
}

#pragma mark - Select Song Request 0x87
#pragma mark - 发送请求某一首歌曲
- (void)requestSelectSong:(int)index
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexString1 = [[NSString alloc] initWithFormat:@"%02lx",(long)index];
        NSString *s1,*s2;
        if (hexString1.length <= 2)
        {
            s1 = [NSString stringWithFormat:@"0x%@",@"00"];
            s2 = [NSString stringWithFormat:@"0x%@",[hexString1 substringFromIndex:0]];
            
        }
        else if (hexString1.length == 3)
        {
            s1 = [NSString stringWithFormat:@"0x%@",[hexString1 substringToIndex:1]];
            s2 = [NSString stringWithFormat:@"0x%@",[hexString1 substringFromIndex:1]];
        }
        else if (hexString1.length == 4)
        {
            s1 = [NSString stringWithFormat:@"0x%@",[hexString1 substringToIndex:2]];
            s2 = [NSString stringWithFormat:@"0x%@",[hexString1 substringFromIndex:2]];
        }
        
        unsigned long a1 = strtoul([s1 UTF8String], 0, 16);
        unsigned long a2 = strtoul([s2 UTF8String], 0, 16);
        unsigned long a = 0x00^0x02^a1^a2;
        NSString *first = [self hexToString:a1];
        NSString *second = [self hexToString:a2];
        NSString *last = [self hexToString:a];
        NSString *hexStr = [self hexToString];
        NSString *hexString = [NSString stringWithFormat:@"55%@8702%@%@%@AA",hexStr,first,second,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 强劲模式、低音开关 0x88
- (void)requestAudioStepChange:(NSString *)data1 withData2:(NSString *)data2
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexStr = [self hexToString];
        NSString *s1 = [[NSString alloc] initWithFormat:@"%02lx",(long)[data1 substringToIndex:2].integerValue];
        NSString *s2 = [[NSString alloc] initWithFormat:@"%02lx",(long)[data2 substringToIndex:2].integerValue];
        unsigned long c1 = strtoul([s1 UTF8String], 0, 16);
        unsigned long c2 = strtoul([s2 UTF8String], 0, 16);
        unsigned long a = 0x00^c1^c2;
        NSString *last = [self hexToString:a];
        NSString *hexString = [NSString stringWithFormat:@"55%@8802%@%@%@AA",hexStr,data1,data2,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark -function setup request 0x89
#pragma mark - 请求进入设置页面
- (void)requestSetting
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexStr = [self hexToString];
        unsigned long a = 0x00^0x01^0x01;
        NSString *last = [self hexToString:a];
        NSString *hexString = [NSString stringWithFormat:@"55%@890101%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 请求闹钟设置页面 0x8A
#pragma mark - 请求环境展示页面
- (void)requestEnvironmentShow
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexStr = [self hexToString];
        unsigned long a = 0x00^0x01^0x01;
        NSString *last = [self hexToString:a];
        NSString *hexString = [NSString stringWithFormat:@"55%@8A0101%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 请求闹钟设置页面 0x8B
- (void)requestClockSetting
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexStr = [self hexToString];
        unsigned long a = 0x00^0x01^0x01;
        NSString *last = [self hexToString:a];
        NSString *hexString = [NSString stringWithFormat:@"55%@8B0101%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

#pragma mark - 请求音效设置页面 0x8C
- (void)requestAudioStepSetting
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexStr = [self hexToString];
        unsigned long a = 0x00^0x01^0x01;
        NSString *last = [self hexToString:a];
        NSString *hexString = [NSString stringWithFormat:@"55%@8C0101%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}


#pragma mark - 请求空气设置页面 0x8D
- (void)requestAIRSetting
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexStr = [self hexToString];
        unsigned long a = 0x00^0x01^0x01;
        NSString *last = [self hexToString:a];
        NSString *hexString = [NSString stringWithFormat:@"55%@8D0101%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}





#pragma mark - ACK
- (void)requestACK
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexStr = [self hexToString];
        unsigned long a = ~0xff;
        NSString *last = [self hexToString:a];
        NSString *hexString = [NSString stringWithFormat:@"55%@ff%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

- (void)requestNACK
{
    PeripheralEntity *entity = [_foundPeripheralArray firstObject];
    if (entity)
    {
        NSString *hexStr = [self hexToString];
        unsigned long a = ~0xf0;
        NSString *last = [self hexToString:a];
        NSString *hexString = [NSString stringWithFormat:@"55%@ff%@AA",hexStr,last];
        NSData *hexData = [self hexStringToBytes:hexString];
        [self writeValue:entity.peripheral characteristic:entity.Characteristic1 data:hexData];
    }
}

/**************************************************结束写数据**********************************************************************/




















+ (BlueToothManager*)sharedInstanced
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[BlueToothManager alloc] init];
        }
    }
    return manager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [super allocWithZone:zone];
            return manager;
        }
    }
    return nil;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
