//
//  PassLockManager.m
//  applock
//
//  Created by 杜学超 on 15/4/28.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

#import "PassLockManager.h"
#import "PassLockViewController.h"
#define ViewTag 1123143543

@interface PassLockManager ()<PasswordDelegate>

@property (nonatomic,strong) PassLockViewController * passLockVC;
@end
@implementation PassLockManager
-(void)showPassLockScreen
{
    UIWindow * win =  [UIApplication sharedApplication].keyWindow;
    PassLockViewController * passLockVC = [[PassLockViewController alloc] init];
    passLockVC.delegate  = self;
    passLockVC.inputtype = InputTypeConfirm;
    passLockVC.addFailAnimation = YES;
    passLockVC.shakeDevice = YES;
    passLockVC.view.tag = ViewTag;
    self.passLockVC = passLockVC;
    [win addSubview:self.passLockVC.view];
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
- (void) resignActive
{
    double delayInSeconds = 0.10f;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
        UIWindow * win =  [UIApplication sharedApplication].keyWindow;
        UIView * a = (UIView *)[win viewWithTag:ViewTag];
        [a removeFromSuperview];
    });
    
}

@end
