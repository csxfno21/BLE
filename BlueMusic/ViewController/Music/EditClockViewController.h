//
//  EditClockViewController.h
//  BlueMusic
//
//  Created by csxfno21 on 15/4/1.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "BaseViewController.h"
#import "BlueToothManager.h"
static NSString *const POST_TIME_NOTI  = @"POST_TIME_NOTI";

typedef enum VOICE_TYPE
{
    VOICE_TYPE_1 = 1,
    VOICE_TYPE_2,
    VOICE_TYPE_3,
}VOICE_TYPE;

@interface EditClockViewController : BaseViewController
@property (nonatomic,assign)BOOL canAddClock;   //添加一个闹钟
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic)NSString *dateAndTime;
@end
