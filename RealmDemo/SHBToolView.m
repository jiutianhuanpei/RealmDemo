//
//  SHBToolView.m
//  RealmDemo
//
//  Created by shenhongbang on 16/6/8.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "SHBToolView.h"
#import "UIView+Helps.h"

CGFloat const ToolInitH = 50;

@interface SHBToolView ()<UITextFieldDelegate>

@end

@implementation SHBToolView {
    UIViewController   *_VC;
    
    UIButton        *_sendBtn;
    UITextField     *_textField;
}

+ (SHBToolView *)addToSuperView:(UIViewController *)VC {
    
    UIView *addView = VC.view;
    
    CGFloat h = CGRectGetHeight(addView.bounds);
    CGFloat w = CGRectGetWidth(addView.bounds);
    
    SHBToolView *toolView = [[SHBToolView alloc] initWithFrame:CGRectMake(0, h - ToolInitH, w, ToolInitH) superView:VC];
    [addView addSubview:toolView];
    return toolView;
}

- (instancetype)initWithFrame:(CGRect)frame superView:(UIViewController *)superView {
    self = [super initWithFrame:frame];
    if (self) {
        _VC = superView;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"Send" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(clickedSend) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn sizeToFit];
        _sendBtn.frame = CGRectMake(CGRectGetWidth(frame) - 30 - CGRectGetWidth(_sendBtn.frame), 0, CGRectGetWidth(_sendBtn.frame), CGRectGetHeight(frame));
        [self addSubview:_sendBtn];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, CGRectGetMinX(_sendBtn.frame) - 10, CGRectGetHeight(frame) - 10)];
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
        _textField.layer.cornerRadius = 5;
        _textField.delegate = self;
        [self addSubview:_textField];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self clickedSend];
    return true;
}


- (void)setMaxY:(CGFloat)y {
    CGRect selfFrame = self.frame;
    
    selfFrame = CGRectMake(selfFrame.origin.x, y - CGRectGetHeight(selfFrame), CGRectGetWidth(selfFrame), CGRectGetHeight(selfFrame));
    
    self.frame = selfFrame;
    if (_toolViewMinY) {
        _toolViewMinY(CGRectGetMinY(self.frame));
    }
}

#pragma mark - 对外
- (void)resignOwner {
    __weak typeof(self) SHB = self;
    [UIView animateWithDuration:0.25 animations:^{
        [SHB setMaxY:CGRectGetHeight([UIScreen mainScreen].bounds)];
    }];
}

- (void)clickedSend {
    [self shbSendAction:@"toolViewClickedSend:" from:self];
    _textField.text = nil;
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    
    [_VC.view bringSubviewToFront:self];
    
    NSValue *frameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [frameValue CGRectValue];
    
    CGFloat maxY = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(rect);
    
    __weak typeof(self) SHB = self;
    [UIView animateWithDuration:0.25 animations:^{
        [SHB setMaxY:maxY];
    }];
//    if (_toolViewMinY) {
//        _toolViewMinY(maxY - CGRectGetHeight(self.frame));
//    }
}

- (void)keyboardWillHidden:(NSNotification *)noti {
    
    [self resignOwner];
}

#pragma mark - getter
- (NSString *)text {
    return _textField.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
