//
//  WZ_PwdVerify.m
//  CYPasswordViewDemo
//
//  Created by qwkj on 2017/6/29.
//  Copyright © 2017年 zhssit. All rights reserved.
//

#import "WZ_PwdVerify.h"
#import "CYPasswordView.h"
#import <objc/runtime.h>

@interface WZ_PwdVerify ()

@property (nonatomic, strong) CYPasswordView *passwordView;

@property (copy, nonatomic) WZ_TapCancelHandler cancelHandler;
@property (copy, nonatomic) WZ_ForgetPwdHandler forgetPwdHandler;
@end

@interface CYPasswordView (verify)

@property (strong, nonatomic) WZ_PwdVerify *verifyManger;
@end
@implementation CYPasswordView (verify)

-(WZ_PwdVerify *)verifyManger{
    return objc_getAssociatedObject(self, @selector(verifyManger));
}
-(void)setVerifyManger:(WZ_PwdVerify *)verifyManger{
    objc_setAssociatedObject(self, @selector(verifyManger), verifyManger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)hide {
    self.verifyManger = nil;
    [self removeFromSuperview];
}
@end

@implementation WZ_PwdVerify
+(instancetype)WZ_showPwdVerifyInView:(UIView *)view InputComplete:(PwdCompleteInPutBlcok )inputComplete{
    WZ_PwdVerify *pwdVerfyModel = [[WZ_PwdVerify alloc]init];
    
    [pwdVerfyModel.passwordView showInView:view];
    pwdVerfyModel.passwordView.verifyManger = pwdVerfyModel;
    
    __weak typeof(pwdVerfyModel) weakModel = pwdVerfyModel;
    pwdVerfyModel.passwordView.finish = ^(NSString *password) {
        if (inputComplete) {
            inputComplete(password,weakModel);
        }
        
    };
    return pwdVerfyModel;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        /** 注册取消按钮点击的通知 */
        [CYNotificationCenter addObserver:self selector:@selector(cancel) name:CYPasswordViewCancleButtonClickNotification object:nil];
        [CYNotificationCenter addObserver:self selector:@selector(forgetPWD) name:CYPasswordViewForgetPWDButtonClickNotification object:nil];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(CYPasswordView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[CYPasswordView alloc] init];
        _passwordView.title = @"输入交易密码";
        _passwordView.loadingText = @"提交中...";
    }
    return _passwordView;
}
-(void)WZ_cancelTapHandler:(void(^)())handler{
    self.cancelHandler = handler;
}
-(void)WZ_forgetPwdHandler:(WZ_ForgetPwdHandler)handler{
    self.forgetPwdHandler = handler;
}
- (void)cancel {
    if(self.cancelHandler)self.cancelHandler();
    if (self.passwordView.verifyManger) {
        self.passwordView.verifyManger=nil;
    }
}

- (void)forgetPWD {
    if(self.forgetPwdHandler)self.forgetPwdHandler();
}
- (void)WZ_LoadingStartWithMsg:(NSString *)msg{
    if(msg)self.passwordView.loadingText = msg;
    [self.passwordView hideKeyboard];
    [self.passwordView startLoading];
}
-(void)WZ_LoadingComplete:(BOOL)Success Msg:(NSString *)msg{
    if (msg) {
        [self.passwordView requestComplete:Success message:msg];
    }else{
        [self.passwordView requestComplete:Success];
    }
    [self.passwordView hideKeyboard];
    [self.passwordView stopLoading];
}
-(void)WZ_hide{
    [self.passwordView hide];
}
@end

