//
//  ZKBaseViewController.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/22.
//

#import <UIKit/UIKit.h>

@interface ZKBaseViewController : UIViewController

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isLoading;//是否加载过数据
@property (nonatomic, assign) BOOL error;//是否加载数据错误
@property (nonatomic, strong, readonly) UITableView *lgjeropj_tableView;//获取视图中的TableView

- (void)lgjeropj_addSubviews;

- (void)lgjeropj_requestData;

- (void)lgjeropj_recoverKeyboard;

- (void)lgjeropj_backBtnClick;

- (void)lgjeropj_layoutNavigation;

- (void)lgjeropj_hideBackButton;

- (void)lgjeropj_refreshControls;

- (void)lgjeropj_addRefreshHeader;

- (void)lgjeropj_addRefreshFooter;

@end
