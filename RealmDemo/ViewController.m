//
//  ViewController.m
//  RealmDemo
//
//  Created by shenhongbang on 16/6/7.
//  Copyright © 2016年 shenhongbang. All rights reserved.
//

#import "ViewController.h"
#import "SHBModel.h"
#import "SHBNetManager.h"
#import "SHBRealmManager.h"
#import "TableViewCell.h"
#import "SHBToolView.h"

@interface ViewController ()<SHBRealmManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController {
    UITableView     *_tableView;
    
    RLMResults      *_result;
    
    SHBToolView     *_toolView;
    
    
    RLMNotificationToken    *_notificationToken;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[SHBRealmManager defaultManger] setDelegate:self];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - ToolInitH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];

    _toolView = [SHBToolView addToSuperView:self];
    __weak typeof(_tableView) tab = _tableView;
    __weak typeof(self) SHB = self;
    [_toolView setToolViewMinY:^(CGFloat minY) {
        tab.frame = CGRectMake(0, 0, CGRectGetWidth(tab.frame), minY);

        [SHB scrollToBottom:true];
    }];

    [self create:@"clean all message" action:@selector(cleanAllMessage) y:200];
    
//    [self getLocationData];
    
    _notificationToken = [[Message allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        
        NSLog(@"%@   %@   %@", results, change, error);
        
        if (error == nil) {
            _result = results;
            if (change == nil) {
                [tab reloadData];
                return ;
            }
            
            [tab beginUpdates];
            
            [tab insertRowsAtIndexPaths:[change insertionsInSection:0] withRowAnimation:UITableViewRowAnimationLeft];
            [tab deleteRowsAtIndexPaths:[change deletionsInSection:0] withRowAnimation:UITableViewRowAnimationRight];
            [tab reloadRowsAtIndexPaths:[change modificationsInSection:0] withRowAnimation:UITableViewRowAnimationFade];
            [tab endUpdates];
            
            
        }
        
    }];
    
}

- (void)cleanAllMessage {
    SHBRealmManager *manager = [SHBRealmManager defaultManger];
    [manager deleteAllMessages:^(NSError *error) {
        if (error == nil) {
            [_tableView reloadData];
        }
    }];
}

- (UIButton *)create:(NSString *)title action:(SEL)action y:(CGFloat)y {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2., y);
    [self.view addSubview:btn];
    return btn;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class]) forIndexPath:indexPath];

    Message *message = [_result objectAtIndex:indexPath.row];
    
    
    [cell configMessage:message];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _result.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = [_result objectAtIndex:indexPath.row];
    return [TableViewCell heightWithMessage:message];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [_toolView resignOwner];
    [self.view endEditing:true];
}

#pragma mark - SHBRealmManagerDelegate
- (void)realmChangeWithNotification:(NSString *)notification realm:(RLMRealm *)realm {
    NSLog(@"delegate:%@    %@", notification, realm);
//    [self getLocationData];
    
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_result.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
    
}

- (void)getLocationData {
    SHBRealmManager *realm = [SHBRealmManager defaultManger];
    _result = [realm getAllMessages];
    [UIView setAnimationsEnabled:false];
    [_tableView reloadData];
    [UIView setAnimationsEnabled:true];
    [self scrollToBottom:false];
}

- (void)scrollToBottom:(BOOL)animated {
    [_tableView scrollRectToVisible:CGRectMake(0, CGRectGetHeight(_tableView.frame) - 1, CGRectGetWidth(_tableView.frame), 1) animated:animated];
}

#pragma mark - viewhelps
- (void)toolViewClickedSend:(SHBToolView *)sender {
    NSLog(@"\n%s  %@", __FUNCTION__, sender);
    if (sender.text.length == 0) {
        return;
    }
    Message *msg = [[Message alloc] init];
    msg.date = [NSDate date];
    msg.text = sender.text;
    msg.isSend = true;
    
    __weak typeof(self) SHB = self;
    SHBRealmManager *realManager = [SHBRealmManager defaultManger];
    
    [realManager updateMessage:msg failure:^(NSError *error) {
        if (error == nil) {
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_result.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
            [SHB scrollToBottom:true];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                SHBNetManager *netManager = [SHBNetManager defaultManager];
                [netManager talkWithTuring:msg.text userID:nil success:^(id object) {
                    
                    NSDictionary *body = object[SHOWAPIBODY];
                    NSString *text = body[@"text"];
                    
                    Message *recMessage = [[Message alloc] init];
                    recMessage.date = [NSDate date];
                    recMessage.isSend = false;
                    recMessage.text = text;
                    [realManager updateMessage:recMessage failure:^(NSError *error) {
                        if (error == nil) {
                            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_result.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
                            [SHB scrollToBottom:true];
                        }
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"error:%@", error);
                }];
            });
        } else {
            NSLog(@"errror:%@", error);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
