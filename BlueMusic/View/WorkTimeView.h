//
//  WorkTimeView.h
//  BlueMusic
//
//  Created by company on 15-4-2.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkTimeView;
@protocol WorkTimeViewDelegate <NSObject>

- (void)workTimeView:(WorkTimeView *)workTimeView withString:(NSString *)str;

@end

@interface WorkTimeView : UIView
@property (nonatomic,assign)id<WorkTimeViewDelegate> delegate;
@end
