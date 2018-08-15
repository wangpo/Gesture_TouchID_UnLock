//
//  SYSGestureLockView.h
//   Demo
//
//  Created by wangpo on 2018/7/31.
//  Copyright © 2018年 王坡. All rights reserved.
//  手势视图

#import <UIKit/UIKit.h>
@class SYSGestureLockView;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@protocol SYSGestureLockViewDelegate <NSObject>

/**
 手势绘制完成回调

 @param lockView 手势视图
 @param gesturePassword 绘制的密码
 */
- (void)gestureLockView:(SYSGestureLockView *)lockView drawRectFinished:(NSMutableString *)gesturePassword;
@end


@interface SYSGestureLockView : UIView

@property (nonatomic, weak) id<SYSGestureLockViewDelegate> delegate;
@property (nonatomic, assign) BOOL hiddenGestureTrack;//隐藏手势轨迹

@end
