//
//  ZKBaseTabBarViewController.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/22.
//

#import "ZKBaseTabBarViewController.h"

@interface ZKBaseTabBarViewController ()

@end

@implementation ZKBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 屏幕方向切换
/// 是否可以旋转
- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}

/// 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}



@end
