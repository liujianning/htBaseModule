//
//  ZKBaseViewController.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/22.
//

#import "ZKBaseViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <MJRefresh/MJRefresh.h>
#import "UIView+Extension.h"

@interface ZKBaseViewController ()

@property (nonatomic, copy) NSString *tableNameKey;

@end

@implementation ZKBaseViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    ZKBaseViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(viewController)
        [viewController lgjeropj_addSubviews];
        [viewController lgjeropj_bindTableView];
        [viewController lgjeropj_refreshControls];
        if (![NSString ht_isEmpty:viewController.tableNameKey]) {
            UITableView *tableView = [viewController valueForKey:viewController.tableNameKey];
            if (tableView.mj_header) {
                [tableView.mj_header beginRefreshing];
            } else {
                [viewController lgjeropj_requestData];
            }
        } else {
            [viewController lgjeropj_requestData];
        }
    }];
    return viewController;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self lgjeropj_recoverKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self lgjeropj_layoutNavigation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)lgjeropj_hideBackButton {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
}

- (void)lgjeropj_addSubviews {
    
}

- (void)lgjeropj_layoutNavigation {
    
}

- (void)lgjeropj_refreshControls {
    
}

- (void)lgjeropj_requestData {
    
}

- (void)lgjeropj_addRefreshHeader {
    
}

- (void)lgjeropj_addRefreshFooter {
    
}

- (void)lgjeropj_bindTableView {
    
    unsigned  int count = 0;
    Ivar *members = class_copyIvarList([self class], &count);
    NSString *keyName = @"";
    NSInteger c = 0 ;
    for (int i = 0; i < count; i++){
        Ivar var = members[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(var)];
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        if ([type isEqualToString:@"@\"UITableView\""] || [type isEqualToString:@"@\"UICollectionView\""]) {
            c += 1;
            keyName = key;
        }
    }
    if (c <= 1) {
        self.tableNameKey = keyName;
        if (![NSString ht_isEmpty:self.tableNameKey]) {
            UITableView *tableView = [self valueForKey:self.tableNameKey];
            if (@available(iOS 11.0, *)) {
                tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
    }
    free(members);
}

- (void)lgjeropj_backBtnClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lgjeropj_recoverKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)count {
    return _count ?: 10;
}

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (UITableView *)lgjeropj_tableView {
    
    if(self.tableNameKey) {
        return [self valueForKey:self.tableNameKey];
    }
    return nil;
}

#pragma mark - 屏幕方向切换
/// 是否可以旋转
- (BOOL)shouldAutorotate {
    return NO;
}

/// 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
