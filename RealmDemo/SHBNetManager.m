//
//  SHBNetManager.m
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "SHBNetManager.h"

NSString *const SHOWAPIBODY = @"showapi_res_body";
NSString *const SHOWAPICODE = @"showapi_res_code";
NSString *const SHOWAPIERROR = @"showapi_res_error";


@interface SHBNetManager ()

@property (nonatomic, strong) AFHTTPSessionManager  *manager;

@end

@implementation SHBNetManager

+ (SHBNetManager *)defaultManager {
    static SHBNetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SHBNetManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 30;
        config.timeoutIntervalForResource = 30;
        
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];

    }
    return self;
}

- (void)POST:(NSString *)path parameters:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *parameter = [self authDic:param];
    [_manager POST:path parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)GET:(NSString *)path parameters:(NSDictionary *)param success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSDictionary *parameter = [self authDic:param];
    [_manager GET:path parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)talkWithTuring:(NSString *)info userID:(NSString *)userid success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *param = [self authDic:nil];
    param[@"info"] = info;
    if (userid.length > 0) {
        param[@"userid"] = userid;
    }
    
    [self GET:@"http://route.showapi.com/60-27" parameters:param success:^(id object) {
        if (success) {
            success(object);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSMutableDictionary *)authDic:(NSDictionary *)dic {
    NSDictionary *par = @{ @"showapi_sign" : @"d8979964f228405884796713256b7a46", @"showapi_appid" : @"20112"};
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:par];
    if (dic != nil) {
        [tempDic setValuesForKeysWithDictionary:dic];
    }
    return tempDic;
}


@end
