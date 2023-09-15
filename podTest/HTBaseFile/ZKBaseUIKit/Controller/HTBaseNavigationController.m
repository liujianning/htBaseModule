//
//  HTBaseNavigationController.m
// 
//
//  Created by Apple on 2022/9/13.
//  Copyright © 2021 huzhongkai. All rights reserved.
//

#import "HTBaseNavigationController.h"

@interface HTBaseNavigationController ()

@end

@implementation HTBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIBarButtonItem *)lgjeropj_backButton:(UIViewController *)target{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //测试-通过主项目调用
//    if([HTKaiguanManager lgjeropj_judgeMovieSwitchStatus]) {
//        [backButton sd_setImageWithURL:kImageNumber(120) forState:UIControlStateNormal];
//    }

    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0,0);
    [backButton sizeToFit];
    SEL backAction = @selector(lgjeropj_backBtnClick);
    if([target respondsToSelector:backAction]){
        [backButton addTarget:target action:backAction forControlEvents:UIControlEventTouchUpInside];
    }
    backButton.bounds = CGRectMake(0, 0, kBarHeight, kBarHeight);
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
