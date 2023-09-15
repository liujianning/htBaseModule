//
//  ZKThemeAdapter.m
//  ZKDemo
//
//  Created by Apple on 2020/4/13.
//  Copyright © 2020 ZKDemo. All rights reserved.
//

#import "ZKThemeAdapter.h"
#import "UIColor+Color.h"

@implementation ZKThemeAdapter


+ (instancetype)shareInstance
{
    static ZKThemeAdapter *var_adapter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        var_adapter = [[ZKThemeAdapter alloc]init];
    });
    return var_adapter;
}

- (UIColor *)ht_dynamicColor:(UIColor *)lightColor andDarkColor:(UIColor *)darkColor
{
#ifdef __IPHONE_13_0
    if (@available(iOS 13.0, *)) {
        UIColor *var_dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            return traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight ? lightColor : darkColor;
        }];
        return var_dyColor;
    } else {
        return lightColor;
    }
#else
    return lightColor;
#endif
    return lightColor;
}

@end
