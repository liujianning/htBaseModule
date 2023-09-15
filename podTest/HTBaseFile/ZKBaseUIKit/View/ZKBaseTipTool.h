//
//  ZKBaseTipTool.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/30.
//

#import <Foundation/Foundation.h>

@interface ZKBaseTipTool : NSObject

/// 单例
+ (instancetype)sharedInstance;

+ (void)showLoadingTip;
+ (void)hideAllLoadingTip;

+ (void)lgjeropj_showDotLoadingTipWithText:(NSString *)text;
+ (void)ht_hideDotLoadingTip;

// 显示消息
+ (void)showMessage:(NSString *)message;

+ (void)ht_showIconMessage:(NSString *)message andIcon:(NSURL *)image duration:(NSTimeInterval)duration;

@end
