//
//  UIView+Helps.m
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "UIView+Helps.h"

@implementation UIView (Helps)

- (BOOL)shbSendAction:(NSString *)actionName from:(id)sender {
    
    SEL action = NSSelectorFromString(actionName);
    id target = sender;
    
    while (target && ![target canPerformAction:action withSender:sender]) {
        target = [target nextResponder];
    }
    
    if (target == nil) {
        return false;
    }
    return [[UIApplication sharedApplication] sendAction:action to:target from:sender forEvent:nil];
}

@end
