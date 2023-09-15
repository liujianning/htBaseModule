//
//  ZKAlertView.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/6/21.
//

#import <UIKit/UIKit.h>

@class ZKAlertView;

typedef void(^BLOCK_ConfirmBlock)(ZKAlertView *alert);
typedef void(^BLOCK_CancelBlock)(ZKAlertView *alert);
typedef void(^BLOCK_CloseBlock)(ZKAlertView *alert);

@interface ZKAlertView : UIView

// 图片
@property (nonatomic, copy) id image;

// 标题
@property (nonatomic, copy) NSString *title;

// 消息
@property (nonatomic, copy) NSString *message;

// 左边按钮文字
@property (nonatomic, copy) NSString *cancelTitle;

//右边按钮文字
@property (nonatomic, copy) NSString *confirmTitle;

//中间按钮文字
@property (nonatomic, copy) NSString *centerTitle;

// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
// 消息颜色
@property (nonatomic, strong) UIColor *messageColor;

//左边按钮文字颜色
@property (nonatomic, strong) UIColor *cancelColor;

// 左边按钮文字颜色
@property (nonatomic, strong) UIColor *var_confirmColor;

//标题文字大小
@property (nonatomic, strong) UIFont *var_titleFont;

//消息文字大小
@property (nonatomic, strong) UIFont *var_messageFont;

//左边按钮文字大小
@property (nonatomic, strong) UIFont *cancelFont;

//右边按钮文字大小
@property (nonatomic, strong) UIFont *confirmFont;

//显示时间
@property (nonatomic, assign) NSTimeInterval var_duration;

//左边点击回调
@property (nonatomic, copy) BLOCK_CancelBlock cancelClick;

//左边点击回调
@property (nonatomic, copy) BLOCK_ConfirmBlock var_confirmClick;

//关闭点击回调
@property (nonatomic, copy) BLOCK_CloseBlock closeClick;

//bottomText点击
@property (nonatomic, copy) BLOCK_ConfirmBlock bottomTextClick;

//点击空白关闭，默认YES
@property (nonatomic, assign) BOOL tapblankToClose;

//#pragma mark 新加方法 传入按钮和文字颜色数组 并且判断是否有下面的按钮
///// 标题数组
//@property (nonatomic,strong) NSArray *titlesArr;
//
///// 颜色数组
//@property (nonatomic,strong) NSArray *colorsArr;
//
//
- (instancetype)initWithView:(UIView *)view;
// 显示
- (void)show;

// 隐藏
- (void)dismiss;


//消息提示（无图片，无按钮）
//@param message 消息
// @param duration 时间

- (void)ht_showMessage:(NSString *)message andDuration:(NSTimeInterval)duration;

//消息提示（有图片，无按钮）
//@param image 图片
//@param message 消息
//@param duration 时间

- (void)ht_showImage:(id)image andMessage:(NSString *)message andDuration:(NSTimeInterval)duration;

//消息提示（有图片，有一个按钮）
//@param image 图片
//@param message 消息

- (void)ht_showImage:(id)image andMessage:(NSString *)message andConfirmTitle:(NSString *)confirmTitle andConfirm:(BLOCK_ConfirmBlock)confirm;

//弹窗(左边取消，右边按钮可定制颜色，标题)
//@param image 图片
//@param message 消息
//@param confirmTitle 右边按钮标题
//@param confirmColor 右边按钮颜色
//@param confirm 右边点击回调

- (void)ht_showImage:(id)image andMessage:(NSString *)message andConfirmTitle:(NSString *)confirmTitle andConfirmColor:(UIColor *)var_confirmColor andConfirm:(BLOCK_ConfirmBlock)confirm;
//弹窗显示
 //@param image 图片
 //@param title 标题
 //@param message 消息
 //@param cancelTitle 左边按钮文字
 //@param confirmTitle 右边按钮文字
 //@param cancel 左边按钮点击回调
// @param confirm 右边按钮点击回调

- (void)ht_showImage:(id)image andTitle:(NSString *)title andMessage:(NSString *)message andCancelTitle:(NSString *)cancelTitle andConfirmTitle:(NSString *)confirmTitle andCancel:(BLOCK_CancelBlock)cancel andConfirm:(BLOCK_ConfirmBlock)confirm;

//弹窗显示
 //@param image 图片
 //@param title 标题
 //@param message 消息
 //@param confirmTitle 右边按钮文字
 //@param Close 关闭按钮点击回调
 //@param confirm 右边按钮点击回调

- (void)ht_showImage:(id)image andTitle:(NSString *)title andHightText:(NSString *)text andHightTextFont:(UIFont *)font andHightTextColor:(UIColor *)textColor andMessage:(NSString *)message andCenterButtonTitle:(NSString *)var_centerButtonTitle andCenterButtonBgImage:(id)centerButtonBgImage andClose:(BLOCK_CloseBlock)close andConfirm:(BLOCK_ConfirmBlock)confirm;

//弹窗显示
 //@param image 图片
 //@param title 标题
 //@param message 消息
// @param confirmTitle 右边按钮文字
// @param Close 关闭按钮点击回调
 //@param confirm 右边按钮点击回调

- (void)ht_showImage:(id)image andTitle:(NSString *)title andMessage:(NSString *)message andCenterButtonTitle:(NSString *)var_centerButtonTitle andCenterButtonBgImage:(id)centerButtonBgImage andBottomText:(NSAttributedString *)text andBottomTap:(BLOCK_ConfirmBlock)bottomTap andClose:(BLOCK_CloseBlock)close andConfirm:(BLOCK_ConfirmBlock)confirm;

@end
