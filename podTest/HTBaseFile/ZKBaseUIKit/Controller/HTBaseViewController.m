//
//  HTBaseViewController.m
// 
//
//  Created by Apple on 2022/9/13.
//  Copyright © 2021 huzhongkai. All rights reserved.
//

#import "HTBaseViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface HTBaseViewController ()

@end

@implementation HTBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor ht_colorWithHexString:@"#232331"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)lgjeropj_layoutNavigation {
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    } else {
        // Fallback on earlier versions
    }
    [self lgjeropj_setTitleFont:[self lgjeropj_titleFont] ?: [UIFont systemFontOfSize:20.0f]];
    [self lgjeropj_setTitleColor:[self lgjeropj_titleColor] ?: [UIColor whiteColor]];
    [self lgjeropj_setBarTintColor:[self lgjeropj_barTintColor] ?: [UIColor ht_colorWithHexString:@"#313143"]];
    [self lgjeropj_setBar_hideShadowImage:YES];
}

- (void)setWhiteBackButton:(BOOL)whiteBackButton{
    _whiteBackButton = whiteBackButton;
    
    if(self.navigationController){
        self.navigationItem.leftBarButtonItem = [self lgjeropj_backButton:self];
    }
}

- (UIBarButtonItem *)lgjeropj_backButton:(UIViewController *)target {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton sd_setImageWithURL:kImageNumber(120) forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0,0);
    //[backButton sizeToFit];
    SEL backAction = @selector(lgjeropj_backBtnClick);
    if([target respondsToSelector:backAction]){
        [backButton addTarget:target action:backAction forControlEvents:UIControlEventTouchUpInside];
    }
    backButton.bounds = CGRectMake(0, 0, kBarHeight*0.8, kBarHeight*0.8);
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)lgjeropj_backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lgjeropj_addRefreshHeader{
    @weakify(self);
    self.lgjeropj_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.startIndex = 1;
        [self lgjeropj_requestData];
    }];
}

- (void)lgjeropj_addRefreshFooter{
    @weakify(self);
    self.lgjeropj_tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.startIndex++;
        [self lgjeropj_requestData];
    }];
    self.lgjeropj_tableView.mj_footer.hidden = YES;
}

- (UIActivityIndicatorView *)backIndicatorView {
    
    if (_backIndicatorView == nil) {
        _backIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectZero];
        _backIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.view addSubview:_backIndicatorView];
        [_backIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.height.equalTo(@(50));
        }];
    }
    [self.view bringSubviewToFront:_backIndicatorView];
    return _backIndicatorView;
}

@end
