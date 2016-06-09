//
//  SHBModel.m
//  RealmDemo
//
//  Created by shenhongbang on 16/6/7.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "SHBModel.h"

@implementation Dog

@end

@implementation Person


@end



@implementation Message


+ (NSString *)primaryKey {
    return @"id";
}

- (NSInteger)id {
    NSTimeInterval time = [_date timeIntervalSince1970];
    NSString *t = [NSString stringWithFormat:@"%.lf", time];
    
    return [t integerValue];
}

@end
















