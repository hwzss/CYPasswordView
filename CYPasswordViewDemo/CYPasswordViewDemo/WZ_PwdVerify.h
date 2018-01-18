//
//  WZ_PwdVerify.h
//  CYPasswordViewDemo
//
//  Created by qwkj on 2017/6/29.
//  Copyright © 2017年 zhssit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;
@class WZ_PwdVerify;

typedef void(^PwdCompleteInPutBlcok)(NSString *pwd,WZ_PwdVerify *verifyManger);
typedef void(^WZ_TapCancelHandler)();
typedef void(^WZ_ForgetPwdHandler)();

@interface WZ_PwdVerify : NSObject
- (void)WZ_LoadingStartWithMsg:(NSString *)msg;
-(void)WZ_LoadingComplete:(BOOL)Success Msg:(NSString *)msg;
-(void)WZ_hide;

-(void)WZ_cancelTapHandler:(WZ_TapCancelHandler)handler;
-(void)WZ_forgetPwdHandler:(WZ_ForgetPwdHandler)handler;

+(instancetype)WZ_showPwdVerifyInView:(UIView *)view InputComplete:(PwdCompleteInPutBlcok )inputComplete;
@end
