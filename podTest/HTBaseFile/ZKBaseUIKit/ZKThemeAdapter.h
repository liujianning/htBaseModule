//
//  ZKThemeAdapter.h
//  ZKDemo
//
//  Created by Apple on 2020/4/13.
//  Copyright © 2020 ZKDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKThemeAdapter : NSObject


/// 单例
+ (instancetype)shareInstance;

/// 动态颜色
/// @param lightColor 亮色
/// @param darkColor 暗黑色
- (UIColor *)ht_dynamicColor:(UIColor *)lightColor andDarkColor:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
