//
//  ZKBaseRoundTextField.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/30.
//

#import "ZKBaseRoundTextField.h"

@implementation ZKBaseRoundTextField

- (void)setLeftImage:(id)leftImage{
    _leftImage = leftImage;
    UIImageView *leftView = [[UIImageView alloc] init];
    if ([leftImage isKindOfClass:[UIImage class]]) {
        leftView.image = leftImage;
    } else if ([leftImage isKindOfClass:[NSURL class]]) {
        [leftView sd_setImageWithURL:leftImage];
    } else if ([leftImage isKindOfClass:[NSString class]]) {
        leftView.image = [UIImage imageNamed:leftImage];
    }
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

//UITextField leftView与输入框的距离
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect rect = [super leftViewRectForBounds:bounds];
    rect.origin.x += self.var_leftOffset;
    return rect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, CGRectGetMaxX(self.leftView.frame)+self.var_textLeftOffset, 0);
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, CGRectGetMaxX(self.leftView.frame)+self.var_textLeftOffset, 0);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self tintButtonClear];
}

- (void) tintButtonClear{
    if(self.var_clearButtonColor){
        UIButton *buttonClear = [self buttonClear];
        if(!buttonClear){
            return;
        }
        buttonClear.tintColor = self.var_clearButtonColor;
        UIImage *imageNormal = [buttonClear imageForState:UIControlStateNormal];
        UIImage *var_imageButtonClearNormal = [[self class] imageWithImage:imageNormal
                                                                     tintColor:self.var_clearButtonColor];
        [buttonClear setImage:var_imageButtonClearNormal forState:UIControlStateHighlighted];
        [buttonClear setImage:var_imageButtonClearNormal forState:UIControlStateNormal];
    }
}

- (UIButton *) buttonClear{
    for(UIView *v in self.subviews){
        if([v isKindOfClass:[UIButton class]]){
            UIButton *buttonClear = (UIButton *) v;
            return buttonClear;
        }
    }
    return nil;
}

+ (UIImage *)imageWithImage:(UIImage *)image tintColor:(UIColor *)tintColor{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = (CGRect){ CGPointZero, image.size };
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    [image drawInRect:rect];
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    UIImage *var_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return var_image;
}



@end
