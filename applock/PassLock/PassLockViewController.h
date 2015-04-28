//
//  PassLockViewController.h
//  applock
//
//  Created by 杜学超 on 15/4/27.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, InputType)
{
    InputTypeSet     = 0,   //设置
    InputTypeChange  = 1,   //修改
    InputTypeConfirm = 2,   //验证
    
};
@protocol PasswordDelegate <NSObject>

@optional

- (void) passwordResult:(BOOL) issuccess inputType:(InputType )type;

@end
@interface PassLockViewController : UIViewController
@property (nonatomic,strong) UITextField * password;
@property (nonatomic,strong) UIScrollView * setPassWordScrollView;
@property (nonatomic,assign) InputType inputtype;
@property (nonatomic,assign) BOOL shakeDevice;     //是否错误的时候震动设备
@property (nonatomic,assign) BOOL addFailAnimation;//是否添加动画
@property (nonatomic,assign) id<PasswordDelegate> delegate;

//获取当前密码
+(NSString *) getCurrentPassWord;
@end
