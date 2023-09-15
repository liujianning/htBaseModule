//
//  HTStringUtils.m
// 
//
//  Created by admin on 2022/12/16.
//  Copyright © 2022 admin. All rights reserved.
//

#import "HTStringUtils.h"

@implementation HTStringUtils

+ (instancetype)sharedInstance{
    static HTStringUtils *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
//图标数字
+ (NSURL *)ht_imageUrlFromNumber:(NSInteger)var_Number {
    NSString *var_Base = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_imageDomain"];
    NSString *var_Picture = [NSString stringWithFormat:@"%@%ld%@%@", var_Base, var_Number, AsciiString(@"@3x"), AsciiString(@".png")];
    return [NSURL URLWithString:var_Picture];
}
// Ascii转字符串
+ (NSString *)ht_asciistring:(id)object {
    if ([object isKindOfClass:[NSString class]]) {
        NSString *result = object;
        return result;
    }else if ([object isKindOfClass:[NSArray class]])  {
        NSString *result = [self ht_stringFromAsciiArray:object];
        return result;
    }
    
    return @"";
}
// Ascii转字符串
+ (NSString *)ht_stringFromAsciiArray:(NSArray *)codeArr {
    NSMutableString *normalStr = [NSMutableString string];
    for (NSNumber *code in codeArr) {
        /*
         测试
         int codeInt = code.intValue - TP_App_Id.intValue;
         NSString *string = [NSString stringWithFormat:@"%c",codeInt];
         */
        NSString *string = [NSString stringWithFormat:@"%c",code.intValue];
        [normalStr appendString:string];
    }
    return normalStr;
}

+ (NSString *)ht_shStringFromAsciiArray:(NSArray *)codeArr {
    
    NSMutableString *normalStr = [NSMutableString string];
    for (NSNumber *code in codeArr) {
        NSString *string = [NSString stringWithFormat:@"%c",code.intValue];
        [normalStr appendString:string];
    }
    return normalStr;
}

- (NSString *)ht_stringWithKid:(id)text {
    NSString *string = @"";
    if ([text isKindOfClass:[NSString class]]) {
        string = text;
    }else {
        string = [NSString stringWithFormat:@"%@%@",@"string",text];
    }
    NSString *str = @"text";
    if (self.var_multiLangDict.count > 0 &&[self.var_multiLangDict.allKeys containsObject:string]) {
        str = [self.var_multiLangDict objectForKey:string];
    }else if (![string hasPrefix:@"string"]) {
        str = string;
    }
    return str;
}
- (void)ht_getLangfileData {
    NSString *var_pathStr = [self lgjeropj_getLangPathString];
    if (var_pathStr && var_pathStr.length > 0) {
        NSData *var_jsonData = [NSData dataWithContentsOfFile:var_pathStr];
        if (var_jsonData != nil) {
            NSDictionary *var_jsonDict = [NSJSONSerialization JSONObjectWithData:var_jsonData options:NSJSONReadingAllowFragments error:nil];
            [self.var_multiLangDict removeAllObjects];
            [self.var_multiLangDict addEntriesFromDictionary:var_jsonDict];
        }
    }
}

- (void)lgjeropj_getLangWithNetwork {
    //测试-通过主项目调用
//    BOOL var_ischange = [self lgjeropj_judgeIfneedRequestLanguage];
//    if (var_ischange == YES) {
//        [[HTNetworkManager shareInstance] post:kNetworkFormat(STATIC_kAppMutilang) param:@{} result:^(id result) {
//            if (TransSuccess(result)) {
//                NSDictionary *var_dataDict = [result objectForKey:@"data"];
//                if (var_dataDict != nil && var_dataDict.count > 0) {
//                    NSDictionary *var_dict = var_dataDict[@"iOS"];
//                    if (var_dict != nil && var_dict.count > 0) {
//                        [self.var_multiLangDict removeAllObjects];
//                        [self.var_multiLangDict addEntriesFromDictionary:var_dict];
//                        BOOL var_result = [self ht_saveFileContentsAtPath:[self lgjeropj_getLangPathString] andContentDic:var_dict];
//                        if (var_result) {
//                            [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:AsciiString(@"CFBundleShortVersionString")] forKey:@"udf_budnum"];
//                            [[NSUserDefaults standardUserDefaults] synchronize];
//                        }
//                    }
//                }
//            }
//            [APP_DELEGATE ht_refreshWindowRootController];
//        }];
//    } else {
//        [APP_DELEGATE ht_refreshWindowRootController];
//    }
}

- (BOOL)lgjeropj_judgeIfneedRequestLanguage {
    BOOL result = NO;
    if ([self ht_isDirectoryOrFileExistAtPath:[self lgjeropj_getLangPathString]]) {
        NSString *budnumStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_budnum"];
        if (![budnumStr isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:AsciiString(@"CFBundleShortVersionString")]]) {
            result = YES;
        }
    } else {
        result = YES;
    }
    return result;
}
- (NSString *)lgjeropj_getLangPathString {
    NSString *var_string = [[[NSUserDefaults standardUserDefaults] objectForKey:AsciiString(@"AppleLanguages")] objectAtIndex:0];
    NSRange var_range = [var_string rangeOfString:@"-" options:NSBackwardsSearch];
    if (var_range.location != NSNotFound) {
        var_string = [var_string substringToIndex:var_range.location];
    } else {
        var_string = var_string.length > 2 ? [var_string substringToIndex:2] : AsciiString(@"en");
    }
    NSString *var_name = [NSString stringWithFormat:@"%@%@%@", AsciiString(@"lang/"), var_string, AsciiString(@".txt")];
    NSString *var_pathStr = [self ht_getDocumentsPathWithString:var_name];
    return var_pathStr;
}
- (NSString *)ht_getDocumentsPathWithString:(NSString *)var_str{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:var_str];
}
- (BOOL)ht_isDirectoryOrFileExistAtPath:(NSString *)var_path {
    BOOL var_result = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:var_path]) {
        var_result = YES;
    }
    return var_result;
}
- (BOOL)ht_createDirectoryAtPath:(NSString *)var_directoryPath {
    if (![self ht_isDirectoryOrFileExistAtPath:var_directoryPath]) {
        NSError *var_error;
        return [[NSFileManager defaultManager] createDirectoryAtPath:var_directoryPath withIntermediateDirectories:YES attributes:nil error:&var_error];
    }
    return YES;

}
- (BOOL)ht_saveFileContentsAtPath:(NSString *)var_path andContentDic:(NSDictionary *)var_contentDic {
    if (![self ht_isDirectoryOrFileExistAtPath:var_path]) {
        [self ht_createDirectoryAtPath:[self ht_getDocumentsPathWithString:AsciiString(@"lang")]];
        NSData *var_jsonData = [NSJSONSerialization dataWithJSONObject:var_contentDic options:0 error:nil];
        if (var_jsonData) {
            return [[NSFileManager defaultManager] createFileAtPath:var_path contents:var_jsonData attributes:nil];
        }
    }
    return YES;
}
#pragma mark- lazy
- (NSMutableDictionary *)var_multiLangDict {
    if (_var_multiLangDict == nil) {
        _var_multiLangDict = [NSMutableDictionary dictionary];
    }
    return _var_multiLangDict;
}

@end
