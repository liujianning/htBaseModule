//
//  NSString+Extension.m
//  ZKBaseSDK
//
//  Created by Apple on 2019/11/20.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Extension)

//判断是否为空
+(BOOL) ht_isEmpty:(NSString *)str{
    str = kFormat(str);
    if (str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]||[str isEqualToString:@"(null)"]||[str isEqualToString:@"<null>"]||[str isEqualToString:@"null"]||str.length == 0) {
        return YES;
    }
    return NO;
}

+(NSString *)ht_isEmpty:(NSString *)str andReplaceStr:(NSString *)var_replaceStr{
    if ([NSString ht_isEmpty:str]) {
        return var_replaceStr;
    }else
    {
        return str;
    }
}

- (CGSize)ht_sizeWithMaxSize:(CGSize)maxSize andTextFont:(UIFont *)font {
    CGRect rect = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}

- (CGSize)ht_sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font{
    return [self ht_sizeWithMaxSize:CGSizeMake(width, MAXFLOAT) andTextFont:font];
}

- (float)ht_getHeightWithFontSize:(int)size width:(float)width{
    return [self ht_sizeWithMaxSize:CGSizeMake(width, MAXFLOAT) andTextFont:[UIFont systemFontOfSize:size]].height;
}

- (NSString*)ht_isEmptyStr {
    if ([NSString ht_isEmpty:self]) {
        return @"";
    } else {
        return self;
    }
}

- (NSString *)ht_base64String {
    if([NSString ht_isEmpty:self]){
        return @"";
    }
    NSData *baseData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [baseData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (BOOL)ht_isNumber:(NSString *)string {
    //判断是不是纯数字
    [NSCharacterSet decimalDigitCharacterSet];
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] ht_trimming].length >0) {
        return NO;
    }else{
        return YES;
    }
}

- (NSString *)ht_trimming {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
