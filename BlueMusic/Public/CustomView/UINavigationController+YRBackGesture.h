//
//  UINavigationController+YRBackGesture.h
//  Mark
//
//  Created by yandaoqiu on 14-7-8.
//  Copyright (c) 2014年 yandaoqiu. All rights reserved.
//

/*!
 *	@class	let NavigationController support slide to right to back to previous VC
 */
#import <UIKit/UIKit.h>

#define BackGestureOffsetXToBack 80//>80 show pre vc

@interface UINavigationController (YRBackGesture)<UIGestureRecognizerDelegate>
/*!
 *	@brief	Default is NO;
 *  @note need call this after ViewDidLoad otherwise not work;
 */
@property (assign,nonatomic) BOOL enableBackGesture;

@end
