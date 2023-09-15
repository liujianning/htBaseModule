//
//  UIViewController+Navigation.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/28.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Navigation)

- (void)lgjeropj_setBarTintColor:(UIColor *)barTintColor;
- (UIColor *)lgjeropj_barTintColor;

- (void)lgjeropj_setTintColor:(UIColor *)tintColor;
- (UIColor *)lgjeropj_tintColor;

- (void)lgjeropj_setTitleFont:(UIFont *)var_titleFont;
- (UIFont *)lgjeropj_titleFont;

- (void)lgjeropj_setTitleColor:(UIColor *)titleColor;
- (UIColor *)lgjeropj_titleColor;

- (void)lgjeropj_setBar_hideShadowImage:(BOOL)bar_hideShadowImage;
- (BOOL)lgjeropj_bar_hideShadowImage;

- (void)lgjeropj_setBar_hidden:(BOOL)bar_hidden;
- (BOOL)lgjeropj_bar_hidden;

+ (UIViewController *)lgjeropj_currentViewController;

@end
