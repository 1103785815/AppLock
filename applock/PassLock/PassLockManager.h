//
//  PassLockManager.h
//  applock
//
//  Created by 杜学超 on 15/4/28.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PassLockManager : NSObject

/**
 *  显示锁屏
 */
- (void) showPassLockScreen;
/**
 *  移除锁屏
 */
- (void) resignActive;
@end
