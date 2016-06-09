//
//  SHBRealmManager.m
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "SHBRealmManager.h"

@implementation SHBRealmManager {
    RLMRealm        *_realm;
    
    RLMNotificationToken    *_notificationToken;
}

+ (SHBRealmManager *)defaultManger {
    static SHBRealmManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SHBRealmManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _realm = [RLMRealm defaultRealm];
    }
    return self;
}

+ (void)setDefaultRealmName:(NSString *)name version:(NSInteger)version updateVersion:(void (^)(RLMMigration *, uint64_t))updateVersion {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    NSURL *fileUrl = [[[config.fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:name] URLByAppendingPathExtension:@"realm"];
    config.fileURL = fileUrl;
    
    config.schemaVersion = version;

    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        
        if (updateVersion) {
            updateVersion(migration, oldSchemaVersion);
        }
    };
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    [RLMRealm defaultRealm];
}

- (void)addMessage:(Message *)message failure:(void(^)(NSError *error))failure {
    NSError *error = nil;
    [_realm transactionWithBlock:^{
        [_realm addObject:message];
    } error:&error];
    if (failure) {
        failure(error);
    }
}

- (void)updateMessage:(Message *)message failure:(void(^)(NSError *error))failure {
    NSError *error = nil;
    [_realm transactionWithBlock:^{
        [Message createInRealm:_realm withValue:message];
    } error:&error];
    if (failure) {
        failure(error);
    }
}

- (void)deleteMessage:(Message *)message  failure:(void(^)(NSError *error))failure {
    NSError *error = nil;
    [_realm transactionWithBlock:^{
        [_realm deleteObject:message];
    } error:&error];
    if (failure) {
        failure(error);
    }
}

- (void)deleteAllMessages:(void(^)(NSError *error))failure {
    NSError *error = nil;
    [_realm transactionWithBlock:^{
        [_realm deleteAllObjects];
    } error:&error];
    if (failure) {
        failure(error);
    }
}

- (Message *)checkMessageWith:(NSString *)iid {
    RLMResults *results = [Message objectsWhere:@"id = %@", iid];
    if (results.count > 0) {
        return [results firstObject];
    }
    return nil;
}

- (RLMResults *)getAllMessages {
    RLMResults *results = [[Message allObjects] sortedResultsUsingProperty:@"date" ascending:true];
    return results;
}

#pragma mark - getter & setter
- (void)setDelegate:(id<SHBRealmManagerDelegate>)delegate {
    _delegate = delegate;
    if (_notificationToken == nil) {
        __weak typeof(_delegate) Dele = _delegate;
        _notificationToken = [_realm addNotificationBlock:^(NSString * _Nonnull notification, RLMRealm * _Nonnull realm) {
            if ([Dele respondsToSelector:@selector(realmChangeWithNotification:realm:)]) {
                [Dele realmChangeWithNotification:notification realm:realm];
            }
        }];
    }
}


#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_notificationToken stop];
    _notificationToken = nil;
}


@end


