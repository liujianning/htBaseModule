//
//  UIView+Extension.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/30.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>
//#import <Masonry/Masonry.h>

static char STATIC_kActionHandlerTapBlockKey;

@implementation UIView (Extension)
    
- (CGFloat)left{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right{
    return CGRectGetMaxX(self.frame);
}

-(void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom{
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint pt = self.center;
    pt.x = centerX;
    self.center = pt;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint pt = self.center;
    pt.y = centerY;
    self.center = pt;
}

- (CGPoint)boundsCenter{
    return CGPointMake(self.width / 2.f, self.height / 2.f);
}

- (CGFloat)boundsCenterX{
    return self.width / 2.f;
}

- (CGFloat)boundsCenterY{
    return self.height / 2.f;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)ht_addTapActionWithBlock:(BLOCK_ZKBaseGestureActionBlock)block
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ht_tapAction:)];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, &STATIC_kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}
- (void)ht_tapAction:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        BLOCK_ZKBaseGestureActionBlock block = objc_getAssociatedObject(self, &STATIC_kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

+ (void)ht_gradientLayerForView:(UIView *)view andFrame:(CGRect)frame
{
    
    for(CALayer *layer in view.layer.sublayers){
        if([layer isKindOfClass:[CAGradientLayer class]]){
            [layer removeFromSuperlayer];
        }
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor ht_colorWithHexString:@"#000000"].CGColor, (__bridge id)[UIColor ht_colorWithHexString:@"#000000"].CGColor];
    gradientLayer.locations = @[@0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0.0, 1);
    gradientLayer.frame = frame;
        
    [view.layer addSublayer:gradientLayer];
}

+ (void)ht_gradientLayerForView:(UIView *)view andFromColor:(UIColor *)fromColor andToColor:(UIColor *)toColor andDirection:(ENUM_CMGradientDirection)direction{
    for(CALayer *layer in view.layer.sublayers){
        if([layer isKindOfClass:[CAGradientLayer class]]){
            [layer removeFromSuperlayer];
        }
    }
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    
    if(direction == ENUM_CMGradientDirectionVertical){
        gl.startPoint = CGPointMake(0.5, 0);
        gl.endPoint = CGPointMake(0.5, 1);

    }else{
        gl.startPoint = CGPointMake(0, 0.5);
        gl.endPoint = CGPointMake(1, 0.5);

    }
    gl.colors = @[(__bridge id)fromColor.CGColor, (__bridge id)toColor.CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [view.layer insertSublayer:gl atIndex:0];
}

@end
