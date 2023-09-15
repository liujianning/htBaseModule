//
//  UIColor+Color.h
//  ZKBaseSDK
//
//  Created by Apple on 2019/11/20.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ENUM_ShadeChangeDirection) {
    
    ENUM_ShadeChangeDirectionLevel,
    ENUM_ShadeChangeDirectionVertical,
    ENUM_ShadeChangeDirectionUpwardDiagonalLine,
    ENUM_ShadeChangeDirectionDownDiagonalLine,
};

@interface UIColor (Color)

+ (instancetype)colorGradientChangeWithSize:(CGSize)size andDirection:(ENUM_ShadeChangeDirection)direction andStartColor:(UIColor *)startcolor andEndColor:(UIColor *)endColor;

//传入颜色值获取颜色
//
//@param r r
//@param g g
//@param b b
//@param a a
//@return 颜色
+ (UIColor *)colorWithRGBA:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;

//传入hex颜色值获取颜色
//
//@param integer 颜色值
//@return 颜色
+ (UIColor *)ht_colorWithHex:(int)integer;

//传入hex颜色值字符串获取颜色
//
//@param hexString 颜色值
//@return 颜色
+ (UIColor *)ht_colorWithHexString:(NSString *)hexString;

- (UIImage *)ht_imageWithSize:(CGSize)size;

@end
