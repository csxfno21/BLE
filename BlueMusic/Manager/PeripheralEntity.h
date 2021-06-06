//
//  PeripheralEntity.h
//  FDQ
//
//  Created by csxfno21 on 14-6-17.
//  Copyright (c) 2014年 com.handsmap.sxb. All rights reserved.
//

/**
 *
 * 外围设备结构
 *
 */


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralEntity : NSObject
{
    NSString *deviceName;
    CBPeripheral *peripheral;
    CBCharacteristic *Characteristic0;
    CBCharacteristic *Characteristic1;
    
}
@property(strong,nonatomic)CBPeripheral *peripheral;
@property(strong,nonatomic)CBCharacteristic *Characteristic0;
@property(strong,nonatomic)CBCharacteristic *Characteristic1;
@property(strong,nonatomic)NSString *deviceName;
@end
