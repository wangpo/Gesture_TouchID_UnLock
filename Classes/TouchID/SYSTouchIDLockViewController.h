//
//  SYSTouchIDLockViewController.h
//   Demo
//
//  Created by wangpo on 2018/7/31.
//  Copyright © 2018年 王坡. All rights reserved.
//  指纹解锁VC

#import <UIKit/UIKit.h>
@class SYSTouchIDLockViewController;

@protocol SYSTouchIDLockViewControllerDelegate <NSObject>
- (void)touchIDUnlockSuccess:(SYSTouchIDLockViewController *)vc;//指纹解锁成功回调
- (void)touchIDUnlockError:(SYSTouchIDLockViewController *)vc message:(NSString *)message;//指纹解锁异常回调
@end

@interface SYSTouchIDLockViewController : UIViewController

@property (nonatomic, weak) id<SYSTouchIDLockViewControllerDelegate> delegate;

@end
