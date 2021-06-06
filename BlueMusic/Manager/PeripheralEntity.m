//
//  PeripheralEntity.m
//  LED
//
//  Created by csxfno21 on 14-6-17.
//  Copyright (c) 2014年 com.company.sxb. All rights reserved.
//

#import "PeripheralEntity.h"

@implementation PeripheralEntity
@synthesize peripheral;
@synthesize Characteristic0;
@synthesize Characteristic1;
@synthesize deviceName;
- (void)dealloc
{
    peripheral = nil;
    Characteristic0 = nil;
    Characteristic1 = nil;
}
@end
