//
//  PasswordViewController.m
//  PrivateAlbums
//
//  Created by Du xuechao on 15/4/20.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

#import "PasswordViewController.h"
#import "InputView.h"
#import "KKKeychain.h"
#define numCount 4
@interface PasswordViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) NSString  * firstInputString;
@property (nonatomic,strong) NSString  * secondInputString;

@property (nonatomic,assign) NSInteger  times;//次数
@property (nonatomic,strong) InputView * inputView0;
@property (nonatomic,strong) InputView * inputView1;
@property (nonatomic,strong) UILabel   * messageLabel0;
@property (nonatomic,strong) UILabel   * messageLabel1;

@property (nonatomic,assign) BOOL isInit;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * presentVC = [UIButton buttonWithType:UIButtonTypeCustom];
    presentVC.frame  = CGRectMake(0, 0, 60, 30);
    presentVC.center = self.view.center;
    [presentVC setBackgroundColor:[UIColor clearColor]];
    [presentVC setTitle:@"退下" forState:UIControlStateNormal];
    [presentVC addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rigButton = [[UIBarButtonItem alloc] initWithCustomView:presentVC];
    self.navigationItem.leftBarButtonItem = rigButton;
    
    _times = 0;
    _password = [[UITextField alloc] init];
    _password.frame = CGRectZero;
    _password.delegate = self;
    _password.keyboardType = UIKeyboardTypeNumberPad;
    [_password becomeFirstResponder];
    [self.view addSubview:_password];
    
    _setPassWordScrollView = [[UIScrollView alloc] init];
    _setPassWordScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _setPassWordScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT );
    _setPassWordScrollView.showsHorizontalScrollIndicator = NO;
    _setPassWordScrollView.backgroundColor = [UIColor purpleColor];
    _setPassWordScrollView.pagingEnabled = YES;
    _setPassWordScrollView.userInteractionEnabled = NO;
    [self.view addSubview:_setPassWordScrollView];
    
     _inputView0 =   [[InputView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 63)];
    [_setPassWordScrollView addSubview:_inputView0];
    _messageLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(0, FRAME_BOTTOM(_inputView0) + 10, SCREEN_WIDTH, 30)];
    _messageLabel0.backgroundColor = [UIColor grayColor];
    _messageLabel0.textAlignment = NSTextAlignmentCenter;
    [self.setPassWordScrollView addSubview:_messageLabel0];
    
    switch (_inputtype) {
        case InputTypeSet:
            _messageLabel0.text = @"您要设置的密码";
            _messageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, FRAME_BOTTOM(_inputView0) + 10, SCREEN_WIDTH, 30)];
            _messageLabel1.text = @"再次输入密码";
            _messageLabel1.backgroundColor = [UIColor grayColor];
            _messageLabel1.textAlignment = NSTextAlignmentCenter;
            [self.setPassWordScrollView addSubview:_messageLabel1];
            break;
        case InputTypeConfirm:
            _messageLabel0.text = @"验证密码";
            break;
        case InputTypeChange:
            _messageLabel0.text = @"原始密码";
            _setPassWordScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT );
            
            _messageLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, FRAME_BOTTOM(_inputView0) + 10, SCREEN_WIDTH, 30)];
            _messageLabel1.text = @"输入新的密码";
            _messageLabel1.backgroundColor = [UIColor grayColor];
            _messageLabel1.textAlignment = NSTextAlignmentCenter;
            [self.setPassWordScrollView addSubview:_messageLabel1];
            break;
        default:
            break;
    }
}
-(void)test
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([result length] <=numCount)
    {
        _password.text = result;
        //设置密码
        if (_inputtype == InputTypeSet)
        {
            [self setAppPassword:result];
        }
        //验证密码
        if (_inputtype == InputTypeConfirm)
        {
            [self appPasswordConfirm:result];
        }
        //更改密码
        if (_inputtype == InputTypeChange)
        {
            [self changePassword:result];
        }
    }
    return NO;
}
#pragma mark--更改密码  3页
- (void)changePassword:(NSString *) result
{
    NSInteger resultcount = [result length];
    NSInteger pageNum = _setPassWordScrollView.contentOffset.x/SCREEN_WIDTH;
    [self inputImageChangeResultCount:resultcount];
    if (resultcount == numCount)
    {
        //第一页的时候
        if (pageNum == 0)
        {
            NSString * getPassword = [KKKeychain getStringForKey:@"PassWord"];
            //如果第一次验证成功
            if ([getPassword isEqualToString:result])
            {
                [self moveScrollerView];
            }
            else
            {
                DLog(@"密码错误");
                return;
            }
 
        }
        //新密码
        if (pageNum == 1)
        {
            _inputView0 =   [[InputView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 100, SCREEN_WIDTH, 63)];
            [_setPassWordScrollView addSubview:_inputView0];
            _messageLabel0 = [[UILabel alloc] init];
            _messageLabel0.frame = CGRectMake(SCREEN_WIDTH*2, FRAME_BOTTOM(_inputView0) + 10, SCREEN_WIDTH, 30);
            _messageLabel0.text  = @"请再输一次";
            _messageLabel0.backgroundColor = [UIColor grayColor];
            _messageLabel0.textAlignment = NSTextAlignmentCenter;
            [_setPassWordScrollView addSubview:_messageLabel0];
            [UIView animateWithDuration:0.25f animations:^{
                [_setPassWordScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0)];
            } completion:^(BOOL finished) {
                if (finished)
                {
                    _firstInputString = result;
                    [_inputView1 removeFromSuperview];
                    _inputView1 = nil;
                    _password.text = @"";
                }
            }];
        }
        if (pageNum == 2)
        {
            //如果第一次输入的新密码和第二次一样的话那么就修改
            if ([_firstInputString isEqualToString:result])
            {
                [KKKeychain setString:result forKey:@"PassWord"];
                DLog(@"修改成功!");
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            else
            {
                //两次输入不一致 回到第二页
                [self moveScrollerView];
                _messageLabel1.text  = @"两次输入不一致,重新输入";

            }
        }
    }
}
-(void) moveScrollerView
{
    _inputView1 =   [[InputView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 100, SCREEN_WIDTH, 63)];
    [_setPassWordScrollView addSubview:_inputView1];
    [UIView animateWithDuration:0.25f animations:^{
        [_setPassWordScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
        
    } completion:^(BOOL finished) {
        if (finished)
        {
            [_inputView0 removeFromSuperview];
            [_messageLabel0 removeFromSuperview];
            _messageLabel1.frame = CGRectMake(SCREEN_WIDTH, FRAME_BOTTOM(_inputView0) + 10, SCREEN_WIDTH, 30);
            _inputView0 = nil;
            _messageLabel0 = nil;
            _password.text = @"";
        }
    }];
}
#pragma mark--验证密码  已经设置了密码之后
-(void) appPasswordConfirm:(NSString *) result
{
    NSInteger resultcount = [result length];
    [self inputImageChangeResultCount:resultcount];
    if (resultcount == numCount)
    {
      NSString * getPassword = [KKKeychain getStringForKey:@"PassWord"];
        if ([getPassword isEqualToString:result])
        {
            DLog(@"验证成功,放行!");
            if ([self.delegate respondsToSelector:@selector(passwordResult:)])
            {
                [self.delegate passwordResult:YES];
            }
        }
        else
        {
            DLog(@"验证失败");
        }
    }
}
#pragma mark--输入时的图片改变
- (void) inputImageChangeResultCount:(NSInteger) resultcount
{
    UIView * backView = [self.view viewWithTag:11];
    [backView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView * imageView = obj;
        if (imageView.tag >= resultcount)
        {
            imageView.image = [UIImage imageNamed:@"box_empty"];
        }
    }];
    UIImageView * backImageView = (UIImageView *)[backView viewWithTag:resultcount-1];
    if (backImageView)
    {
        backImageView.image = [UIImage imageNamed:@"box_filled"];
    }
}
#pragma mark - 设置密码
- (BOOL ) setAppPassword:(NSString *)result
{
    NSInteger resultcount = [result length];
    [self inputImageChangeResultCount:resultcount];
    if (resultcount == numCount)
    {
        if (_times == 0)
        {
            _firstInputString = result;
        }
        //第二次比较字符串
        if (![_firstInputString isEqualToString:result]) {
            DLog(@"两次输入不一样");
            _messageLabel0.text = @"两次输入不一致,重新输入!";
            _inputView0 =   [[InputView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 63)];
            [_setPassWordScrollView addSubview:_inputView0];
            [UIView animateWithDuration:0.25f animations:^{
                //第一次输入的值交给全局
                [_setPassWordScrollView setContentOffset:CGPointMake(0, 0)];
            } completion:^(BOOL finished) {
                if (finished)
                {
                    _password.text = @"";
                    [_inputView1 removeFromSuperview];
                    _inputView1 = nil;
                }
                _times = 0;
            }];
            
            return NO;
        }
        //如果为第二页的话就不在去初始化
        if (_setPassWordScrollView.contentOffset.x != SCREEN_WIDTH)
        {
            _inputView1 =   [[InputView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 100, SCREEN_WIDTH, 63)];
            [_setPassWordScrollView addSubview:_inputView1];
        }
        else
        {
            NSLog(@"设置完毕,两次输入一致!"); //保存到钥匙串
            [KKKeychain setString:result forKey:@"PassWord"];
            if ([self.delegate respondsToSelector:@selector(passwordResult:)])
            {
                [self.delegate passwordResult:YES];
            }
            return NO;
        }
        //如果第一次输入完毕
        [UIView animateWithDuration:0.25f animations:^{
            //第一次输入的值交给全局
            [_setPassWordScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
        } completion:^(BOOL finished) {
            if (finished)
            {
                _password.text = @"";
                [_inputView0 removeFromSuperview];
                _inputView0 = nil;
            }
            _times = _times + 1;
        }];
    }
    return NO;
}

@end
