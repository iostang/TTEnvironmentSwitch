//
//  TTDebugView.h
//  TTEnvironmentSwitch
//
//  Created by TangChi on 16/8/8.
//  Copyright © 2016年 tangchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TTDebugType) {
    TTDebugTypeWithDevelop      = 1,//开发模式
    TTDebugTypeWithDistribution = 2,//生产模式
    TTDebugTypeWithLocal        = 3,//本地模式
};


@interface UIButton (DragCategory)

@property(nonatomic,assign,getter = isDragEnable)   BOOL dragEnable;
@property(nonatomic,assign,getter = isAdsorbEnable) BOOL adsorbEnable;

@end

/** 此model可以根据业务需求扩展 */
@interface TTDebugModel : NSObject

/**
 *  IP 地址
 */
@property (nonatomic, copy  ) NSString  *tt_kIP;

/**
 *  当前类型
 */
@property (nonatomic, assign) NSInteger tt_kCurrentType;

/** 早AppDelegate初始化时需要先配置一下 */
+ (TTDebugModel *)configDebugModelWithIP:(NSString *)IP
                                    type:(NSInteger)type;

@end

@interface TTDebugView : UIButton


@end
