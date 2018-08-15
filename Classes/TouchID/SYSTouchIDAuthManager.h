//
//  SYSTouchIDAuthManager.h
//   Demo
//
//  Created by wangpo on 2018/7/9.
//  Copyright © 2018年 SGCC. All rights reserved.
//  指纹解锁管理类

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef void (^SuccessCallback)(void);//认证成功回调
typedef void (^FailureCallback)(LAError errorCode);//认证失败回调
typedef void (^NonsupportCallback)(LAError errorCode);//不支持认证回调

@interface SYSTouchIDAuthManager : NSObject
/**
 * 指纹验证
 */
+ (void)touchIDAuthenticationSuccessCallBack:(SuccessCallback)successBlock
                             failureCallback:(FailureCallback)failureBlock
                          nonsupportCallback:(NonsupportCallback)nonsupportBlock;

@end
