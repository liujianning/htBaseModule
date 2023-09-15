//
//  HTCommonUtils.m
//  TalkFreely
//
//  Created by Apple on 2022/5/25.
//  Copyright © 2021 Apple. All rights reserved.
//

#import "HTCommonUtils.h"
//#import <Reachability/Reachability.h>

@implementation HTCommonUtils

+ (BOOL)transIsSuccess:(id)result{
    NSString *code2 = kFormat(result[@"status"]).ht_isEmptyStr;
    if(code2.length > 0){
        return [code2 isEqualToString:@"0"] ||
        [code2 isEqualToString:@"200"] ||
        [code2 isEqualToString:AsciiString(@"SUCCESS")];
    }
    NSString *code1 = kFormat(result[@"var_code"]).ht_isEmptyStr;
    if(code1.length > 0){
        return [code1 isEqualToString:@"0"];
    }
    NSString *code3 = kFormat(result[@"success"]).ht_isEmptyStr;
    if(code3.length > 0){
        return [code3 boolValue];
    }
    return NO;
}

+ (NSString *)ht_getNowTime{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *var_timeSp = [NSString stringWithFormat:@"%.0f", time];
    return var_timeSp;
}

+ (NSString *)ht_getNowTimeTen{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *var_timeSp = [NSString stringWithFormat:@"%.0f", time];
    return var_timeSp;
}

+ (BOOL)textFieldOfRegex:(NSString*)regex andText:(NSString*)text {
    NSPredicate *pred = [NSPredicate predicateWithFormat:AsciiString(@"SELF MATCHES %@"), regex];
    return [pred evaluateWithObject:text];
}

+ (void)ht_shareWithElseAppWithTitle:(NSString *)title andUrl:(NSString *)urlString andSourceRect:(CGRect)sourceRect andDoneBlock:(UIActivityViewControllerCompletionWithItemsHandler)doneBlock{
    UIViewController *currentVC = [UIViewController lgjeropj_currentViewController];
    if(![currentVC isKindOfClass:NSClassFromString(AsciiString(@"UIActivityContentViewController"))]){
        NSURL *URL = [NSURL URLWithString:urlString];
        NSArray *activityItems = @[title ?: @"", URL ?: @""];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        if(kDevice_Is_iPad){
            activityVC.popoverPresentationController.sourceView = currentVC.view;
            activityVC.popoverPresentationController.sourceRect = sourceRect;
        }
        activityVC.completionWithItemsHandler = doneBlock;
        [[UIViewController lgjeropj_currentViewController] presentViewController:activityVC animated:YES completion:nil];
    }
}

+ (void)ht_playVieoWithId:(NSString *)videoId andType:(ENUM_HTVideoType)type andSource:(NSInteger)source {

    //测试-通过主项目调用
//    UINavigationController *nav = [UIViewController lgjeropj_currentViewController].navigationController;
//    NSMutableArray *controllers = nav.viewControllers.mutableCopy;
//    BOOL flag = NO;
//    for (UIViewController *vc in controllers) {
//        if([vc isKindOfClass:[HTVideoPlayerViewController class]]){
//            flag = YES;
//            [controllers removeObject:vc];
//            break;
//        }
//    }
//    HTVideoPlayerViewController *vc = [[HTVideoPlayerViewController alloc] init];
//    [vc lgjeropj_setBar_hidden:YES];
//    vc.type = type;
//    vc.movieId = videoId;
//    vc.var_source = source;
//    [nav pushViewController:vc animated:YES];
//    if(flag){
//        [controllers addObject:vc];
//        nav.viewControllers = controllers;
//    }
}

+ (void)ht_shareWithDataId:(NSString *)var_videoId andName:(NSString *)var_name andType:(NSInteger)var_Type andSourceRect:(CGRect)sourceRect andDoneBlock:(UIActivityViewControllerCompletionWithItemsHandler)doneBlock{

    //纯影视剧分享，非锁分享
    NSString *title = nil;
    NSString *var_link = nil;
    if(var_Type == ENUM_HTVideoTypeTv){
        NSString *var_ttlink = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_ttlink"];
        NSString *var_title = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_tttext"];
        var_ttlink = [var_ttlink stringByAppendingFormat:@"%@%@%@",AsciiString(@"?para1="), var_videoId, AsciiString(@"&para2=3")];
        NSString *var_name1 = kFormat(var_name).ht_isEmptyStr;
        var_name1 = [var_name1 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        var_ttlink = [var_ttlink stringByAppendingFormat:@"%@%@", AsciiString(@"&para3="), var_name1];
        var_title = [var_title stringByReplacingOccurrencesOfString:AsciiString(@"xxx") withString:var_name1];
        var_ttlink = [var_ttlink stringByAppendingFormat:@"%@%@",AsciiString(@"&para4="), TP_App_Id];
        var_link = var_ttlink;
    }else{
        NSString *var_mlink = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_mlink"];
        NSString *var_title = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_mtext"];
        var_mlink = [var_mlink stringByAppendingFormat:@"%@%@%@", AsciiString(@"?para1="), var_videoId, AsciiString(@"&para2=2")];
        NSString *var_name1 = kFormat(var_name).ht_isEmptyStr;
        var_name1 = [var_name1 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        var_mlink = [var_mlink stringByAppendingFormat:@"%@%@", AsciiString(@"&para3="), var_name1];
        var_title = [var_title stringByReplacingOccurrencesOfString:AsciiString(@"xxx") withString:var_name1];
        var_mlink = [var_mlink stringByAppendingFormat:@"%@%@",AsciiString(@"&para4="), TP_App_Id];
        var_link = var_mlink;
    }
    [HTCommonUtils ht_shareWithElseAppWithTitle:title andUrl:var_link andSourceRect:sourceRect andDoneBlock:doneBlock];
}

// 字幕缓存地址
+ (NSString *)ht_subtitlesCachePathWithSubtitleId:(NSString *)subtitleName{
    NSString *var_cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *pathName = [NSString stringWithFormat:@"%@%@", @"/", @"var_subtitles"];
    var_cachePath = [var_cachePath stringByAppendingFormat:@"%@", pathName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:var_cachePath]){
        [fm createDirectoryAtPath:var_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    var_cachePath = [var_cachePath stringByAppendingFormat:@"/%@", subtitleName];
    return var_cachePath;
}

//如果想要判断设备是ipad，要用如下方法
+ (BOOL)ht_getIsIpad{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
    //这两个防范判断不准，不要用
    //#define is_iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    //#define is_iPad (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
}

@end
