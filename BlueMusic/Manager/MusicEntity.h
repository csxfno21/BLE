//
//  MusicEntity.h
//  LED
//
//  Created by company on 14-6-24.
//  Copyright (c) 2014年 com.company.sxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicEntity : NSObject
{

    NSString *musician; //演唱家
    NSString *musicName; //歌名
    NSString *beatsPerMin;//每分钟节拍
    NSString *rating; //0...5
    NSURL *url;
//    UIImage *musicImage;
}

@property (nonatomic, retain) NSString *musician;
@property (nonatomic, retain) NSString *musicName;
@property (nonatomic, retain) NSString *beatsPerMin;
@property (nonatomic, retain) NSString *rating;
@property (nonatomic, retain) NSURL *url;
//@property (nonatomic, retain) UIImage *musicImage;
@end
