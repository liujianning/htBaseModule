//
//  UIColor+Color.m
//  ZKBaseSDK
//
//  Created by Apple on 2019/11/20.
//

#import "UIColor+Color.h"

@implementation UIColor (Color)

+ (UIColor*)colorWithRGBA:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

+ (UIColor *)ht_colorWithHex:(int)integer{
    return [UIColor colorWithRed:((float)((integer & 0xFF0000) >> 16))/255.0  green:((float)((integer & 0xFF00) >> 8))/255.0 blue:((float)(integer & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *)ht_colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned var_hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &var_hexComponent];
    return var_hexComponent / 255.0;
}

+ (instancetype)colorGradientChangeWithSize:(CGSize)size andDirection:(ENUM_ShadeChangeDirection)direction andStartColor:(UIColor *)startcolor andEndColor:(UIColor *)endColor {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    if (direction == ENUM_ShadeChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case ENUM_ShadeChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case ENUM_ShadeChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case ENUM_ShadeChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case ENUM_ShadeChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

- (UIImage *)ht_imageWithSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
