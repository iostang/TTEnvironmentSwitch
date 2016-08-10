//
//  TTNetWorkClient.m
//  TTEnvironmentSwitch
//
//  Created by TangChi on 16/8/8.
//  Copyright © 2016年 tangchi. All rights reserved.
//
#import "TTNetWorkClient.h"
#import "TTDebugView.h"
#import "AppDelegate.h"

//超时设置
#define TIMEOUT 40

@interface TTNetWorkClient ()

/* 请求操作管理 */
@property (nonatomic, strong) AFHTTPRequestOperationManager *AFNManager;

@end

@implementation TTNetWorkClient

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.AFNManager = [AFHTTPRequestOperationManager manager];
        [self.AFNManager.requestSerializer setTimeoutInterval:TIMEOUT];
        self.AFNManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.AFNManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.AFNManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.AFNManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    }
    
    return self;
}

#pragma mark 创建单例
+(instancetype) shareClient {
    
    static TTNetWorkClient *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark GET 请求
- (void)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(LoadSuccess)success
                        failure:(LoadFailure)failure {

    NSString *urlString = [self configuUrl: URLString];
    
    [self.AFNManager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}

#pragma mark POST 请求
- (void)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(LoadSuccess)success
                         failure:(LoadFailure)failure {
    
    
    NSString *urlString = [self configuUrl: URLString];
    
    [self.AFNManager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}


#pragma mark 配置 Url

- (NSString *)configuUrl:(NSString *)url {
    

    NSString *result = nil;
    
    if (kDebug) {
        
        AppDelegate * delegate = [[UIApplication sharedApplication] delegate];
        TTDebugModel *model = delegate.debugModel;
        result = [model.tt_kIP stringByAppendingString: url];
        
    } else {
    
        result = [kIP stringByAppendingString: url];
        
    }
    
    return result;
}

@end
