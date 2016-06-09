//
//  TableViewCell.m
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell ()

//@property (nonatomic, strong) UITextView    *textView;

@end


@implementation TableViewCell {
    UILabel     *_content;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _content = [[UILabel alloc] initWithFrame:CGRectZero];
        _content.font = [UIFont systemFontOfSize:13];
        _content.numberOfLines = 0;
        [self addSubview:_content];
        _content.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _content.layer.borderColor = [UIColor grayColor].CGColor;
    }
    return self;
}

- (void)configMessage:(Message *)message {
    CGFloat width = CGRectGetWidth(self.frame) - 150;
    
    _content.text = message.text;
    
    CGRect rect = [message.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _content.font} context:nil];
    if (message.isSend) {
        _content.textAlignment = NSTextAlignmentRight;
        _content.frame = CGRectMake(CGRectGetWidth(self.frame) - 10 - CGRectGetWidth(rect), 5, CGRectGetWidth(rect) , CGRectGetHeight(rect));
        
    } else {
        _content.textAlignment = NSTextAlignmentLeft;
        _content.frame = CGRectMake(10, 5, CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
}


+ (CGFloat)heightWithMessage:(Message *)message {
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) - 150;
    CGRect rect = [message.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];

    CGFloat height = 5 + CGRectGetHeight(rect) + 5;
    
    return height;
}

    
@end
