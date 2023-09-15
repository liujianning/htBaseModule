//
//  ZKBaseEdgeInsetButton.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/30.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ENUM_ZKButtonEdgeInsetsStyle) {
    ENUM_ZKButtonEdgeInsetsStyleImageLeft,
    ENUM_ZKButtonEdgeInsetsStyleImageRight,
    ENUM_ZKButtonEdgeInsetsStyleImageTop,
    ENUM_ZKButtonEdgeInsetsStyleImageBottom
};

@interface ZKBaseEdgeInsetButton : UIButton

#if TARGET_INTERFACE_BUILDER
@property (nonatomic) IBInspectable NSUInteger edgeInsetsStyle;
#else
@property (nonatomic) ENUM_ZKButtonEdgeInsetsStyle edgeInsetsStyle;
#endif
@property (nonatomic) IBInspectable CGFloat imageTitleSpace;
@property (nonatomic) IBInspectable NSInteger standbyTag;

@end
