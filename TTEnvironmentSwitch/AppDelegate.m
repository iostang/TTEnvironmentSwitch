//
//  AppDelegate.m
//  TTEnvironmentSwitch
//
//  Created by TangChi on 16/8/8.
//  Copyright © 2016年 tangchi. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TTDebugView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    /** 调用位置 设置rootviewcontroller 之前 */
    [self configDebug];
    
    
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    
    
    /** 调用位置 makeKeyAndVisible之后 */
    [TTDebugView new];
    
    
    return YES;
}

- (void)configDebug {
    
    if (kDebug) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        TTDebugType type = [ud integerForKey:kCurrentType];
        
        switch (type) {
            case TTDebugTypeWithDevelop: {
                self.debugModel = [TTDebugModel configDebugModelWithIP:kIP type:TTDebugTypeWithDevelop];
                break;
            }
            case TTDebugTypeWithDistribution: {
                self.debugModel = [TTDebugModel configDebugModelWithIP:kIP_Dis type:TTDebugTypeWithDistribution];
                break;
            }
            case TTDebugTypeWithLocal: {
                self.debugModel = [TTDebugModel configDebugModelWithIP:kIP_Local type:TTDebugTypeWithLocal];
                break;
            }
            default: {
                self.debugModel = [TTDebugModel configDebugModelWithIP:kIP type:TTDebugTypeWithDevelop];
                break;
            }
        }
        
    }
}

@end
