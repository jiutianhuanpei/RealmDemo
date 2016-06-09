//
//  SHBNetManager.h
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

extern NSString *const SHOWAPIBODY;
extern NSString *const SHOWAPICODE;
extern NSString *const SHOWAPIERROR;

@interface SHBNetManager : NSObject

+ (SHBNetManager *)defaultManager;

- (void)POST:(NSString *)path parameters:(NSDictionary *)param success:(void(^)(id object))success failure:(void(^)(NSError *error))failure;
- (void)GET:(NSString *)path parameters:(NSDictionary *)param success:(void(^)(id object))success failure:(void(^)(NSError *error))failure;

- (void)talkWithTuring:(NSString *)info userID:(NSString *)userid success:(void(^)(id object))success failure:(void(^)(NSError *error))failure;


@end
