//
//  TestViewController.m
//  applock
//
//  Created by 杜学超 on 15/4/27.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

#import "TestViewController.h"
#import "KKKeychain.h"
#import "PassLockViewController.h"
@interface TestViewController ()<PasswordDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshPassWord];
    BOOL switchValue = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Switch"] boolValue];
    _lockSwitch.on = switchValue;
    
}
- (IBAction)swichAction:(id)sender
{
    UISwitch * switch1 = sender;
    NSLog(@"%d",switch1.on);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",switch1.on] forKey:@"Switch"];
}
- (IBAction)setPassWord:(id)sender
{
    PassLockViewController * passLockVC = [[PassLockViewController alloc] init];
    passLockVC.inputtype = InputTypeSet;
    passLockVC.addFailAnimation = YES;
    passLockVC.shakeDevice = YES;
    passLockVC.delegate  = self;
    [self presentViewController:passLockVC animated:YES completion:nil];
}
- (IBAction)checkPassWord:(id)sender
{
    PassLockViewController * passLockVC = [[PassLockViewController alloc] init];
    passLockVC.inputtype = InputTypeConfirm;
    passLockVC.addFailAnimation = YES;
    passLockVC.shakeDevice = YES;
    passLockVC.delegate  = self;
    [self presentViewController:passLockVC animated:YES completion:nil];
}
- (IBAction)updatePassWord:(id)sender
{
    PassLockViewController * passLockVC = [[PassLockViewController alloc] init];
    passLockVC.inputtype = InputTypeChange;
    passLockVC.addFailAnimation = YES;
    passLockVC.shakeDevice = YES;
    passLockVC.delegate  = self;
    [self presentViewController:passLockVC animated:YES completion:nil];

}
#pragma mark -- PasswordDelegate
-(void)passwordResult:(BOOL)issuccess inputType:(InputType)type
{
    if (type == InputTypeSet)
    {
        NSLog(@"两次一致设置成功");
        [self dismiss];
        [self refreshPassWord];
        return;
    }
    if (type == InputTypeConfirm)
    {
        [self dismiss];
        [self refreshPassWord];
        return;
    }
    if (type == InputTypeChange)
    {
        [self dismiss];
        [self refreshPassWord];
        return;
    }
}
- (void) dismiss
{
    double delayInSeconds = 0.25f;
    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
-(void) refreshPassWord
{
    _currentPassword.text =  [NSString stringWithFormat:@"当前密码:%@",[PassLockViewController getCurrentPassWord]];
}
@end
