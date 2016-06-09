//
//  TableViewCell.h
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBModel.h"

@interface TableViewCell : UITableViewCell

//@property (nonatomic, strong) UITextView    *textView;


- (void)configMessage:(Message *)message;

+ (CGFloat)heightWithMessage:(Message *)message;



@end
