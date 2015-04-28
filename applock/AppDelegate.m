//
//  AppDelegate.m
//  applock
//
//  Created by 杜学超 on 15/4/27.
//  Copyright (c) 2015年 Du xuechao. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"
#import "PassLockManager.h"
@interface AppDelegate ()
@property (nonatomic,strong) PassLockManager * passManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.2
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestViewController * vc = [[TestViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSString *switchValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"Switch"];
    if ([switchValue isEqualToString:@"1"])
    {
        self.passManager = [[PassLockManager alloc] init];
        [self.passManager showPassLockScreen];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
@end
