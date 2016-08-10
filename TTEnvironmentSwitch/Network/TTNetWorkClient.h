//
//  TTNetWorkClient.h
//  TTEnvironmentSwitch
//
//  Created by TangChi on 16/8/8.
//  Copyright © 2016年 tangchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^LoadSuccess)(id responseObject);
typedef void (^LoadFailure)(NSError *error);

@interface TTNetWorkClient : NSObject

+ (instancetype) shareClient;

- (void)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(LoadSuccess)success
                        failure:(LoadFailure)failure;


- (void)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(LoadSuccess)success
                         failure:(LoadFailure)failure;


@end