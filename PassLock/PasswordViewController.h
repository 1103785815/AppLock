//
//  PasswordViewController.h
//  PrivateAlbums
//
//  Created by Du xuechao on 15/4/20.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

//#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, InputType)
{
   InputTypeSet     = 0,
   InputTypeChange  = 1,
   InputTypeConfirm = 2,

};
@protocol PasswordDelegate <NSObject>

@optional

- (void) passwordResult:(BOOL) issuccess;

@end
@interface PasswordViewController : UIViewController
@property (nonatomic,strong) UITextField * password;
@property (nonatomic,strong) UIScrollView * setPassWordScrollView;
@property (nonatomic,assign) InputType inputtype;
@property (nonatomic,assign) id<PasswordDelegate> delegate;
@end
