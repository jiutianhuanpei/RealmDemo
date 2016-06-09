//
//  SHBRealmManager.h
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "SHBModel.h"

@protocol SHBRealmManagerDelegate <NSObject>

@optional
- (void)realmChangeWithNotification:(NSString *)notification realm:(RLMRealm *)realm;

@end


@interface SHBRealmManager : NSObject

@property (nonatomic, assign) id<SHBRealmManagerDelegate> delegate;

+ (SHBRealmManager *)defaultManger;

/**
 *  设置默认数据库名称  版本号
 */
+ (void)setDefaultRealmName:(NSString *)name version:(NSInteger)version updateVersion:(void(^)(RLMMigration *migration, uint64_t oldSchemaVersion))updateVersion;


//
- (void)addMessage:(Message *)message failure:(void(^)(NSError *error))failure;
- (void)updateMessage:(Message *)message failure:(void(^)(NSError *error))failure;
- (void)deleteMessage:(Message *)message  failure:(void(^)(NSError *error))failure;
- (void)deleteAllMessages:(void(^)(NSError *error))failure;



- (Message *)checkMessageWith:(NSString *)iid;
- (RLMResults *)getAllMessages;



@end
