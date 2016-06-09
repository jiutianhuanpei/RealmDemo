//
//  SHBModel.h
//  RealmDemo
//
//  Created by shenhongbang on 16/6/7.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class Person;

@interface Dog  : RLMObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;


@property (nonatomic, strong) Person *owner;

@end

RLM_ARRAY_TYPE(Dog)     //如果有数组包含 Dog 类，一定要定义 RLMArray<Dog>


@interface Person : RLMObject

@property (nonatomic, copy) NSString    *name;
@property (nonatomic, assign) NSInteger iid;
@property (nonatomic, copy) NSString    *city;
@property (nonatomic, strong) RLMArray<Dog>  *dogs;     //数组一定要写入 <type>
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger iiid;
@property (nonatomic, assign) NSInteger iiiid;

@end

RLM_ARRAY_TYPE(Person)


@interface Message : RLMObject

@property  BOOL  isSend;
@property  NSString *text;
@property  NSDate *date;
@property  NSInteger id;


@end













