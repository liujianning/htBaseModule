//
//  NSString+Extension.h
//  ZKBaseSDK
//
//  Created by Apple on 2019/11/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kFormat(text) [NSString stringWithFormat:@"%@",text]

@interface NSString (Extension)

// 判断是否是纯数字
+ (BOOL)ht_isNumber:(NSString *)string;

// 判断字符串是否为空
+ (BOOL)ht_isEmpty:(NSString *)str;

// 判断字符串是否为空,如果为空替换为指定字符串
+ (NSString *)ht_isEmpty:(NSString *)str andReplaceStr:(NSString *)var_replaceStr;

#pragma mark - 字符串替换 -

- (CGSize)ht_sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font;

//获取字符串高度
- (float)ht_getHeightWithFontSize:(int)size width:(float)width;

//Base64编码
- (NSString *)ht_base64String;

- (NSString *)ht_isEmptyStr;

- (NSString *)ht_trimming;

@end
