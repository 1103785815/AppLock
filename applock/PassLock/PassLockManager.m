//
//  PassLockManager.m
//  applock
//
//  Created by 杜学超 on 15/4/28.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

#import "PassLockManager.h"
#import "PassLockViewController.h"
@interface PassLockManager ()<PasswordDelegate>
@property (nonatomic,strong) PassLockViewController * passLockVC;
@end
@implementation PassLockManager
-(void)showPassLockScreen
{
    if (_passLockVC.view != nil) {
        [_passLockVC.view removeFromSuperview];
        _passLockVC = nil;
    }
    //添加view
    NSString * passWord = [PassLockViewController getCurrentPassWord];
    if (passWord.length)
    {
        self.passLockVC = [[PassLockViewController alloc] init];
        self.passLockVC.delegate  = self;
        self.passLockVC.inputtype = InputTypeConfirm;
        self.passLockVC.addFailAnimation = YES;
        self.passLockVC.shakeDevice = YES;
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self.passLockVC.view];
    }
}
#pragma mark -- 成功之后调取的代理
-(void)passwordResult:(BOOL)issuccess inputType:(InputType)type
{
    if (InputTypeConfirm)
    {
        [self removeFromWindow];
    }
}
- (void) removeFromWindow
{
    [UIView animateWithDuration:0.25f animations:^{
        _passLockVC.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_passLockVC.view removeFromSuperview];
        _passLockVC = nil;
    }];
}

@end
