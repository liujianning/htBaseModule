//
//  ZKBaseNavigationController.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/22.
//

#import "ZKBaseNavigationController.h"

@interface ZKBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ZKBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count >0) {
        if (!viewController.navigationItem.leftBarButtonItem) {
            viewController.navigationItem.leftBarButtonItem =  [self lgjeropj_backButton:viewController];
        }
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIBarButtonItem *)lgjeropj_backButton:(UIViewController *)target{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton sd_setImageWithURL:kImageNumber(120) forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0,0);
    [backButton sizeToFit];
    SEL backAction = @selector(lgjeropj_backBtnClick);
    if([target respondsToSelector:backAction]){
        [backButton addTarget:target action:backAction forControlEvents:UIControlEventTouchUpInside];
    }
    backButton.bounds = CGRectMake(0, 0, kBarHeight, kBarHeight);
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

#pragma mark - 设置滑动返回-
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count == 1){
        //关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - 屏幕方向切换
/// 是否可以旋转
- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

/// 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
