//
//  UIViewController+Navigation.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/28.
//

#import "UIViewController+Navigation.h"
#import <objc/runtime.h>

static char STATIC_tintColorKey;
static char STATIC_barTintColorKey;
static char STATIC_titleFontKey;
static char STATIC_titleColorKey;
static char STATIC_hideShadowImageKey;
static char STATIC_barHiddenKey;

@implementation UIViewController (Navigation)

- (void)lgjeropj_setBarTintColor:(UIColor *)barTintColor{
    objc_setAssociatedObject(self, &STATIC_barTintColorKey, barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.navigationController){
        if (@available(iOS 13.0, *)) {
            UINavigationBar *navBar = self.navigationController.navigationBar;
            UINavigationBarAppearance *appearance = navBar.scrollEdgeAppearance ?: navBar.standardAppearance;
            if(!appearance){
                appearance = [[UINavigationBarAppearance alloc] init];
            }
            appearance.backgroundColor = barTintColor;
            navBar.scrollEdgeAppearance = navBar.standardAppearance = appearance;
        } else {
            self.navigationController.navigationBar.barTintColor = barTintColor;
        }
    }
}

- (UIColor *)lgjeropj_barTintColor{
    return objc_getAssociatedObject(self, &STATIC_barTintColorKey);
}

- (void)lgjeropj_setTintColor:(UIColor *)tintColor{
    objc_setAssociatedObject(self, &STATIC_tintColorKey, tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.navigationController){
        self.navigationController.navigationBar.tintColor = tintColor;
    }
}

- (UIColor *)lgjeropj_tintColor{
    return objc_getAssociatedObject(self, &STATIC_tintColorKey);
}

- (void)lgjeropj_setTitleFont:(UIFont *)var_titleFont{
    objc_setAssociatedObject(self, &STATIC_titleFontKey, var_titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.navigationController){
        if (@available(iOS 13.0, *)) {
            UINavigationBar *navBar = self.navigationController.navigationBar;
            UINavigationBarAppearance *appearance = navBar.scrollEdgeAppearance ?: navBar.standardAppearance;
            if(!appearance){
                appearance = [[UINavigationBarAppearance alloc] init];
            }
            NSMutableDictionary *titleTextAttributes =  [self.navigationController.navigationBar.titleTextAttributes mutableCopy];
            if(!titleTextAttributes){
                titleTextAttributes = @{}.mutableCopy;
            }
            titleTextAttributes[NSFontAttributeName] = var_titleFont;
            appearance.titleTextAttributes = titleTextAttributes;
            if(var_titleFont){
                appearance.buttonAppearance.normal.titleTextAttributes = appearance.buttonAppearance.highlighted.titleTextAttributes = @{
                    NSFontAttributeName: var_titleFont
                };
            }
            navBar.scrollEdgeAppearance = navBar.standardAppearance = appearance;
        }else{
            NSMutableDictionary *titleAttr =  [self.navigationController.navigationBar.titleTextAttributes mutableCopy];
            if(!titleAttr){
                titleAttr = @{}.mutableCopy;
            }
            titleAttr[NSFontAttributeName] = var_titleFont;
            self.navigationController.navigationBar.titleTextAttributes = titleAttr;
        }
    }
}

- (UIFont *)lgjeropj_titleFont{
    return objc_getAssociatedObject(self, &STATIC_titleFontKey);
}

- (void)lgjeropj_setTitleColor:(UIColor *)titleColor{
    objc_setAssociatedObject(self, &STATIC_titleColorKey, titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if(self.navigationController){
        if (@available(iOS 13.0, *)) {
            UINavigationBar *navBar = self.navigationController.navigationBar;
            UINavigationBarAppearance *appearance = navBar.scrollEdgeAppearance ?: navBar.standardAppearance;
            if(!appearance){
                appearance = [[UINavigationBarAppearance alloc] init];
            }
            NSMutableDictionary *titleTextAttributes =  [self.navigationController.navigationBar.titleTextAttributes mutableCopy];
            if(!titleTextAttributes){
                titleTextAttributes = @{}.mutableCopy;
            }
            titleTextAttributes[NSForegroundColorAttributeName] = titleColor;
            appearance.titleTextAttributes = titleTextAttributes;
            if(titleColor){
                appearance.buttonAppearance.normal.titleTextAttributes = appearance.buttonAppearance.highlighted.titleTextAttributes = @{
                    NSForegroundColorAttributeName: titleColor
                };
            }
            navBar.scrollEdgeAppearance = navBar.standardAppearance = appearance;
        }else{
            NSMutableDictionary *titleAttr =  [self.navigationController.navigationBar.titleTextAttributes mutableCopy];
            if(!titleAttr){
                titleAttr = @{}.mutableCopy;
            }
            titleAttr[NSForegroundColorAttributeName] = titleColor;
            self.navigationController.navigationBar.titleTextAttributes = titleAttr;
        }
    }
}

- (UIColor *)lgjeropj_titleColor{
    return objc_getAssociatedObject(self, &STATIC_titleColorKey);
}

- (void)lgjeropj_setBar_hideShadowImage:(BOOL)bar_hideShadowImage{
    objc_setAssociatedObject(self, &STATIC_hideShadowImageKey, [NSNumber numberWithBool:bar_hideShadowImage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (@available(iOS 13.0, *)) {
        UINavigationBar *navBar = self.navigationController.navigationBar;
        UINavigationBarAppearance *appearance = navBar.scrollEdgeAppearance ?: navBar.standardAppearance;
        if(!appearance){
            appearance = [[UINavigationBarAppearance alloc] init];
        }
        appearance.shadowColor = [UIColor clearColor];
        appearance.shadowImage = (bar_hideShadowImage == YES) ? [UIImage new] : nil;
        navBar.scrollEdgeAppearance = navBar.standardAppearance = appearance;
    }else{
        self.navigationController.navigationBar.shadowImage = (bar_hideShadowImage == YES) ? [UIImage new] : nil;
    }
}

- (BOOL)lgjeropj_bar_hideShadowImage{
    return [objc_getAssociatedObject(self, &STATIC_hideShadowImageKey) boolValue];
}

- (void)lgjeropj_setBar_hidden:(BOOL)bar_hidden{
    objc_setAssociatedObject(self, &STATIC_barHiddenKey, [NSNumber numberWithBool:bar_hidden], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.fd_prefersNavigationBarHidden = bar_hidden;
}

- (BOOL)lgjeropj_bar_hidden{
    return [objc_getAssociatedObject(self, &STATIC_barHiddenKey) boolValue];
}

+ (UIViewController *_Nullable)lgjeropj_currentViewController
{
    __block UIViewController *viewController = nil;
    void (^ block)(void) = ^{
        UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        viewController = [self ht_findCurrentViewControllerFromRootViewController:rootViewController andRoot:YES];
    };
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    return viewController;
}

+ (UIViewController *)ht_findCurrentViewControllerFromRootViewController:(UIViewController *)viewController andRoot:(BOOL)var_isRoot {
    
    UIViewController *var_currentViewController = nil;
    if (viewController.presentedViewController) {
        viewController = [self ht_findCurrentViewControllerFromRootViewController:viewController.presentedViewController andRoot:NO];
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        var_currentViewController = [self ht_findCurrentViewControllerFromRootViewController:[(UITabBarController *)viewController selectedViewController] andRoot:NO];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        // 根视图为UINavigationController
        var_currentViewController = [self ht_findCurrentViewControllerFromRootViewController:[(UINavigationController *)viewController visibleViewController] andRoot:NO];
    } else if ([viewController respondsToSelector:NSSelectorFromString(@"contentViewController")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        UIViewController *tempViewController = [viewController performSelector:NSSelectorFromString(@"contentViewController")];
#pragma clang diagnostic pop
        if (tempViewController) {
            var_currentViewController = [self ht_findCurrentViewControllerFromRootViewController:tempViewController andRoot:NO];
        }
    } else if (viewController.childViewControllers.count == 1 && var_isRoot) {
        var_currentViewController = [self ht_findCurrentViewControllerFromRootViewController:viewController.childViewControllers.firstObject andRoot:NO];
    } else {
        var_currentViewController = viewController;
    }
    return var_currentViewController;
}

@end
