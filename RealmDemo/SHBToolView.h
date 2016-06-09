//
//  SHBToolView.h
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const ToolInitH;

@interface SHBToolView : UIView

@property (nonatomic, strong, readonly) NSString *text;


@property (nonatomic, copy) void(^toolViewMinY)(CGFloat minY);
+ (SHBToolView *)addToSuperView:(UIViewController *)VC;



- (void)resignOwner;

@end
