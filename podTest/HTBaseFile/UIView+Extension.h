//
//  UIView+Extension.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/30.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ENUM_CMGradientDirection){
    ENUM_CMGradientDirectionVertical,
    ENUM_CMGradientDirectionHorizontal
};

typedef void (^BLOCK_ZKBaseGestureActionBlock)(UIGestureRecognizer *recoginzer);

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat cornerRadius;

// 添加tap手势
- (void)ht_addTapActionWithBlock:(BLOCK_ZKBaseGestureActionBlock)block;

+ (void)ht_gradientLayerForView:(UIView *)view andFrame:(CGRect)frame;

+ (void)ht_gradientLayerForView:(UIView *)view andFromColor:(UIColor *)fromColor andToColor:(UIColor *)toColor andDirection:(ENUM_CMGradientDirection)direction;

@end
