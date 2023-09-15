//
//  HTCommonUtils.h
//  TalkFreely
//
//  Created by Apple on 2022/5/25.
//  Copyright © 2021 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTCommonUtils : NSObject

// 判断接口是否成功
+ (BOOL)transIsSuccess:(id)result;

// 获取当前时间戳 - 13位
+ (NSString *)ht_getNowTime;

// 获取当前时间戳 - 10位
+ (NSString *)ht_getNowTimeTen;

// 正则匹配
+ (BOOL)textFieldOfRegex:(NSString*)regex andText:(NSString*)text;

// 字幕缓存地址
+ (NSString *)ht_subtitlesCachePathWithSubtitleId:(NSString *)var_fileName;

//如果想要判断设备是ipad，要用如下方法
+ (BOOL)ht_getIsIpad;

// 播放视频
// @param videoId 视频ID
// @param type 视频类型
+ (void)ht_playVieoWithId:(NSString *)videoId andType:(ENUM_HTVideoType)type andSource:(NSInteger)source;
// 分享
// @param title 标题
// @param urlString url
// @param sourceRect ipa需要
+ (void)ht_shareWithElseAppWithTitle:(NSString *)title andUrl:(NSString *)urlString andSourceRect:(CGRect)sourceRect andDoneBlock:(UIActivityViewControllerCompletionWithItemsHandler)doneBlock;

+ (void)ht_shareWithDataId:(NSString *)var_videoId andName:(NSString *)var_name andType:(NSInteger)var_type andSourceRect:(CGRect)sourceRect andDoneBlock:(UIActivityViewControllerCompletionWithItemsHandler)doneBlock;

@end
