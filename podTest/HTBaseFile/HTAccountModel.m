//
//  HTAccountModel.m
// 
//
//  Created by Apple on 2023/2/22.
//  Copyright © 2023 Apple. All rights reserved.
//

#import "HTAccountModel.h"

static HTAccountModel *var_user = nil;
static dispatch_once_t onceToken;

@implementation HTAccountModel

+ (HTAccountModel *)sharedInstance{
    
    dispatch_once(&onceToken, ^{
        var_user = [[HTAccountModel alloc] init];
        NSData *var_jsonData = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"var_HTUserInfoKey"] mj_JSONString] dataUsingEncoding:NSUTF8StringEncoding];
        if (var_jsonData) {
            NSError *var_err;
            NSDictionary *var_jsonDic = [NSJSONSerialization JSONObjectWithData:var_jsonData options:NSJSONReadingMutableContainers error:&var_err];
            if(var_jsonDic){
                [var_user mj_setKeyValues:var_jsonDic];
            }
        }
        NSLog(@"__当前用户状态：%d", var_user.var_isLogin);
        
    });
    return var_user;
}

- (void)clearUserInfo
{
    onceToken = 0;
    var_user = nil;
    
    //其他
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"var_HTUserInfoKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)ht_setUserInfo:(id)userInfo {
    NSMutableDictionary *archiveUser = nil;
    NSData *var_jsonData = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"var_HTUserInfoKey"] mj_JSONString] dataUsingEncoding:NSUTF8StringEncoding];
    if (var_jsonData) {
        NSError *var_err;
        NSDictionary *var_jsonDic = [NSJSONSerialization JSONObjectWithData:var_jsonData options:NSJSONReadingMutableContainers error:&var_err];
        if(var_jsonDic){
            archiveUser = [NSMutableDictionary dictionaryWithDictionary:var_jsonDic];
        }
    }
    NSMutableDictionary *currentUser = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    if (!archiveUser) {
        archiveUser = currentUser;
        for (NSString *key in archiveUser.allKeys) {
            [archiveUser setObject:archiveUser[key] ?: @"" forKey:key];
        }
    } else {
        for (NSString *key in currentUser.allKeys) {
            [archiveUser setObject:currentUser[key] ?: @"" forKey:key];
        }
    }
    //赋值
    [[HTAccountModel sharedInstance] mj_setKeyValues:archiveUser];
    [[NSUserDefaults standardUserDefaults] setObject:[[HTAccountModel sharedInstance].mj_keyValues mj_JSONString] forKey:@"var_HTUserInfoKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)ht_isVip
{
    if ([self ht_isServerVip] || [self ht_isLocalVip] || [self ht_isFamilyVip] || [self ht_isDeviceVip]) {
        return YES;
    }
    return NO;
}

- (BOOL)ht_isServerVip
{
    if ([HTAccountModel sharedInstance].var_isLogin) {
        if ([HTAccountModel sharedInstance].var_bindPlanState != nil && [HTAccountModel sharedInstance].var_bindPlanState.length > 0) {
            return [[HTAccountModel sharedInstance].var_bindPlanState boolValue];
        }
    }
    return NO;
}

- (BOOL)ht_isFamilyVip
{
    if ([HTAccountModel sharedInstance].var_isLogin) {
        if ([HTAccountModel sharedInstance].var_familyPlanState != nil && [HTAccountModel sharedInstance].var_familyPlanState.length > 0) {
            return [[HTAccountModel sharedInstance].var_familyPlanState boolValue];
        }
    }
    return NO;
}

- (NSString *)ht_pidByLocalVip {
    
    NSString *var_localData = [[NSUserDefaults standardUserDefaults] objectForKey:STATIC_kIsFinishSubscribe];
    if (![NSString ht_isEmpty:var_localData]) {
        NSDictionary *var_localDataObj = [var_localData mj_JSONObject];
        return kFormat(var_localDataObj[kSubscribeProductIdKey]).ht_isEmptyStr;
    }
    return @"";
}

+ (NSString *)ht_getNowTime{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *var_timeSp = [NSString stringWithFormat:@"%.0f", time];
    return var_timeSp;
}

- (BOOL)ht_isLocalVip
{
    BOOL var_local = NO;
    NSString *var_localData = [[NSUserDefaults standardUserDefaults] objectForKey:STATIC_kIsFinishSubscribe];
    if(![NSString ht_isEmpty:var_localData]){
        NSDictionary *var_localDataObj = [var_localData mj_JSONObject];
        NSString *var_localStatus = kFormat(var_localDataObj[kSubscribeProductStatusKey]).ht_isEmptyStr;
        NSString *var_localExpireDate = kFormat(var_localDataObj[kSubscribeExpireDateKey]).ht_isEmptyStr;
        if (var_localStatus != nil && var_localStatus.length > 0) {
            var_local = [var_localStatus boolValue];
        } else if (var_localExpireDate != nil && var_localExpireDate.length > 0) {
            NSString *var_currentTime = [self.class ht_getNowTime];
            long var_n = [var_currentTime longLongValue];
            long var_o = [var_localExpireDate longLongValue];
            if (var_localExpireDate.length < 13) {
                var_o = [var_localExpireDate longLongValue] * 1000;
            }
            if(var_o > var_n){
                var_local = YES;
            } else {
                var_local = NO;
            }
        }
    }
    return var_local;
}

- (BOOL)ht_isDeviceVip {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"udf_isDeviceVip"];
}

+ (void)ht_accountPersistence {
    [[HTAccountModel sharedInstance] ht_setUserInfo:[HTAccountModel sharedInstance].mj_keyValues];
}


@end
