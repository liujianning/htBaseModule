//
//  ZKAlertView.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/6/21.
//

#import "ZKAlertView.h"
#import "UIView+Extension.h"
//#import "ZKBaseSDK.h"
#import <Masonry/Masonry.h>

#define MARGIN 23.5
#define DEFAULT_ANIMATION_TIME 0.2
@interface ZKAlertView ()

//内容视图
@property (nonatomic, strong) UIView *contentView;
//图片
@property (nonatomic, strong) UIImageView *imageView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//文字描述
@property (nonatomic, strong) UILabel *messageLabel;
//左边按钮
@property (nonatomic, strong) UIButton *cancelButton;
//右边按钮
@property (nonatomic, strong) UIButton *confirmButton;
//中间按钮
@property (nonatomic, strong) UIButton *var_centerButton;
//右上角关闭按钮
@property (nonatomic, strong) UIButton *var_closeButton;
//中间按钮背景
@property (nonatomic, strong) id var_centerButtonBgImage;

@property (nonatomic, strong) NSString *var_hightText;
@property (nonatomic, strong) UIFont *var_hightTextFont;
@property (nonatomic, strong) UIColor *var_hightTextColor;
/// 是否是查看大图
@property (nonatomic, assign) BOOL isSeeImage;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) NSAttributedString *var_bottomText;
@property (nonatomic, strong) UIView *showView;
@end

@implementation ZKAlertView

- (instancetype)initWithView:(UIView *)view
{
    if (self = [super init]) {
        [self configWithView:view];
    }
    return self;
}

- (void)configWithView:(UIView *)view {
    self.showView = view;
    _image = nil;
    _title = @"";
    _message = @"";
    _cancelTitle = @"";
    _confirmTitle = @"";//
    _titleColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#1A1A1A"] andDarkColor:[UIColor ht_colorWithHexString:@"#D3D3D3"]];
    _messageColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#222222"] andDarkColor:[UIColor ht_colorWithHexString:@"#CCCCCC"]];
    _cancelColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#999999"] andDarkColor:[UIColor ht_colorWithHexString:@"#808080"]];
    _var_confirmColor = [UIColor ht_colorWithHexString:@"#4974F5"];
    _var_titleFont = [UIFont boldSystemFontOfSize:18];
    self.var_messageFont = [UIFont systemFontOfSize:14];
    _cancelFont = [UIFont systemFontOfSize:16];
    _confirmFont = [UIFont boldSystemFontOfSize:16];
    _var_duration = 1.5;
    _tapblankToClose = YES;
    kself;
    self.userInteractionEnabled = YES;
    [self ht_addTapActionWithBlock:^(UIGestureRecognizer *recoginzer) {
        if(weakSelf.tapblankToClose){
            [weakSelf dismiss];
        }
    }];
}

- (void)ht_showMessage:(NSString *)message andDuration:(NSTimeInterval)duration
{
    self.message = message;
    self.var_duration = duration;
    
    [self show];
}

- (void)ht_showImage:(id)image andMessage:(NSString *)message andDuration:(NSTimeInterval)duration
{
    self.image = image;
    self.message = message;
    self.var_duration = duration;
    
    [self show];
}

- (void)ht_showImage:(id)image andMessage:(NSString *)message andConfirmTitle:(NSString *)confirmTitle andConfirm:(BLOCK_ConfirmBlock)confirm
{
    self.image = image;
    self.message = message;
    self.confirmTitle = confirmTitle;
    self.var_confirmClick = confirm;
    
    [self show];
}

- (void)ht_showImage:(id)image andMessage:(NSString *)message andConfirmTitle:(NSString *)confirmTitle andConfirmColor:(UIColor *)var_confirmColor andConfirm:(BLOCK_ConfirmBlock)confirm
{
    self.image = image;
    self.message = message;
    self.cancelTitle = LocalString(@"Cancel", nil);
    self.confirmTitle = confirmTitle;
    self.var_confirmColor = var_confirmColor;
    self.var_confirmClick = confirm;
    
    [self show];
}

- (void)ht_showImage:(id)image andTitle:(NSString *)title andMessage:(NSString *)message andCancelTitle:(NSString *)cancelTitle andConfirmTitle:(NSString *)confirmTitle andCancel:(BLOCK_CancelBlock)cancel andConfirm:(BLOCK_ConfirmBlock)confirm
{
    self.image = image;
    self.title = title;
    self.message = message;
    self.cancelTitle = cancelTitle;
    self.confirmTitle = confirmTitle;
    self.cancelClick = cancel;
    self.var_confirmClick = confirm;
    
    [self show];
}

- (void)ht_showImage:(id)image andTitle:(NSString *)title andHightText:(NSString *)text andHightTextFont:(UIFont *)font andHightTextColor:(UIColor *)textColor andMessage:(NSString *)message andCenterButtonTitle:(NSString *)var_centerButtonTitle andCenterButtonBgImage:(id)var_centerButtonBgImage andClose:(BLOCK_CloseBlock)close andConfirm:(BLOCK_ConfirmBlock)confirm{
    self.image = image;
    self.title = title;
    self.message = message;
    self.centerTitle = var_centerButtonTitle;
    self.var_centerButtonBgImage = var_centerButtonBgImage;
    self.closeClick = close;
    self.var_confirmClick = confirm;
    self.var_hightText = text;
    self.var_hightTextFont = font;
    self.var_hightTextColor = textColor;
    [self ht_showCloseButton];
}

- (void)ht_showImage:(id)image andTitle:(NSString *)title andMessage:(NSString *)message andCenterButtonTitle:(NSString *)var_centerButtonTitle andCenterButtonBgImage:(id)var_centerButtonBgImage andBottomText:(NSAttributedString *)text andBottomTap:(BLOCK_ConfirmBlock)bottomTap andClose:(BLOCK_CloseBlock)close andConfirm:(BLOCK_ConfirmBlock)confirm{
    self.image = image;
    self.title = title;
    self.message = message;
    self.centerTitle = var_centerButtonTitle;
    self.var_centerButtonBgImage = var_centerButtonBgImage;
    self.closeClick = close;
    self.var_confirmClick = confirm;
    self.var_bottomText = text;
    self.bottomTextClick = bottomTap;
    
    [self ht_showBottomTextView];
}

#pragma mark - 显示
- (void)ht_showBottomTextView{
    [self ht_setupUIAndBottomText];
    
    self.hidden = NO;
    [UIView animateWithDuration:DEFAULT_ANIMATION_TIME animations:^{
        self.alpha = 1;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)ht_showCloseButton{
    [self ht_setupUIAndClose];
    
    self.hidden = NO;
    [UIView animateWithDuration:DEFAULT_ANIMATION_TIME animations:^{
        self.alpha = 1;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)show
{
    [self lgjeropj_setupUI];
    
    self.hidden = NO;
    [UIView animateWithDuration:DEFAULT_ANIMATION_TIME animations:^{
        self.alpha = 1;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    if ([self.cancelTitle isEqualToString:@""] &&
        [self.confirmTitle isEqualToString:@""] &&
        [self.centerTitle isEqualToString:@""]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.var_duration + DEFAULT_ANIMATION_TIME) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:DEFAULT_ANIMATION_TIME animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

#pragma mark - 设置UI
- (void)lgjeropj_setupUI
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.frame = self.showView.frame;
    [self.showView addSubview:self];
    [self.showView bringSubviewToFront:self];
    
    [self removeSubviews];
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.alpha = 0;
    
    if ([self.image isKindOfClass:[NSURL class]]) {
        [self.imageView sd_setImageWithURL:self.image];
    } else if ([self.image isKindOfClass:[NSString class]]) {
        self.imageView.image = [UIImage imageNamed:self.image];
    } else {
        self.imageView.image = self.image;
    }
    
    self.titleLabel.textColor = self.titleColor;
    self.titleLabel.text = self.title;
    self.titleLabel.font = self.var_titleFont;
    
    self.messageLabel.textColor = self.messageColor;
    self.messageLabel.text = self.message;
    self.messageLabel.font = self.var_messageFont;
    
    self.cancelButton.titleLabel.font = self.cancelFont;
    [self.cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:self.cancelColor forState:UIControlStateNormal];
    
    self.confirmButton.titleLabel.font = self.confirmFont;
    [self.confirmButton setTitle:self.confirmTitle forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:self.var_confirmColor forState:UIControlStateNormal];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.confirmButton];
    
    [self ht_setConstraints];
    
    self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
}

- (void)ht_setupUIAndClose{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.frame = UIScreen.mainScreen.bounds;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    [self removeSubviews];
    
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.alpha = 0;
    
    if ([self.image isKindOfClass:[NSURL class]]) {
        [self.imageView sd_setImageWithURL:self.image];
    } else if ([self.image isKindOfClass:[NSString class]]) {
        self.imageView.image = [UIImage imageNamed:self.image];
    } else {
        self.imageView.image = self.image;
    }
    
    self.titleLabel.textColor = self.titleColor;
    self.titleLabel.font = self.var_titleFont;
    if(![NSString ht_isEmpty:self.var_hightText]){
        NSString *contentTxt = [kFormat(self.title) ht_isEmptyStr];
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:contentTxt];
        NSRange range = [contentTxt rangeOfString:self.var_hightText];
        if(range.location != NSNotFound){
            [content addAttributes:@{
                NSFontAttributeName: self.var_hightTextFont,
                NSForegroundColorAttributeName: self.var_hightTextColor
            } range:range];
        }
        self.titleLabel.attributedText = content;
    }else{
        self.titleLabel.text = self.title;
    }
    
    self.messageLabel.textColor = self.messageColor;
    self.messageLabel.text = self.message;
    self.messageLabel.font = self.var_messageFont;
    
    self.confirmButton.titleLabel.font = self.confirmFont;
    [self.confirmButton setTitle:self.confirmTitle forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:self.var_confirmColor forState:UIControlStateNormal];
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.var_centerButton];
    [self.contentView addSubview:self.var_closeButton];
    [self.var_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 33));
    }];
    [self ht_setConstraints];
    
    self.contentView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.contentView.backgroundColor = [UIColor ht_colorWithHexString:@"#232331"];
    [self.var_centerButton setTitle:self.centerTitle forState:UIControlStateNormal];
    [self.var_centerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.var_centerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    if ([self.var_centerButtonBgImage isKindOfClass:[NSURL class]]) {
        [self.var_centerButton sd_setBackgroundImageWithURL:self.var_centerButtonBgImage forState:UIControlStateNormal];
    } else if ([self.var_centerButtonBgImage isKindOfClass:[NSString class]]) {
        [self.var_centerButton setBackgroundImage:[UIImage imageNamed:self.var_centerButtonBgImage] forState:UIControlStateNormal];
    } else if ([self.var_centerButtonBgImage isKindOfClass:[UIImage class]]) {
        [self.var_centerButton setBackgroundImage:self.var_centerButtonBgImage forState:UIControlStateNormal];
    }
}

- (void)ht_setupUIAndBottomText{
    self.bottomLabel.attributedText = self.var_bottomText;
    [self.contentView addSubview:self.bottomLabel];
    self.bottomLabel.userInteractionEnabled = YES;
    kself
    [self.bottomLabel ht_addTapActionWithBlock:^(UIGestureRecognizer *recoginzer) {
        if(weakSelf.bottomTextClick){
            weakSelf.bottomTextClick(weakSelf);
        }
    }];
    
    [self ht_setupUIAndClose];
}

#pragma mark - 设置约束
- (void)ht_setConstraints
{
    //相关判断
    CGFloat contentWidth = [self ht_minContentWidth];
    contentWidth = 270;
    
    CGFloat contentHeight = 0;
    
    ///图片距离顶部距离
    CGFloat imgTop = 0;
    ///图片的宽高
    CGFloat imgHeight = 0;
    ///标题距离图片的距离
    CGFloat titleTop = 0;
    ///标题的高度
    CGFloat titleHeight = 0;
    ///内容距离顶部的距离
    CGFloat messageTop = 0;
    ///内容高度
    CGFloat messageHeight = 0;
    ///内容底部
    CGFloat messageBottom = 0;
    ///底部按钮高度
    CGFloat bottomViewHeight = 0;
    
    ///图片不是空
    if (self.image != nil) {
        
        imgHeight = 80;
        imgTop = 24;
        self.imageView.hidden = NO;
        
        titleTop = 20;
        
    }else{
        
        imgHeight = 0;
        imgTop = 0;
        self.imageView.hidden = YES;
        
        titleTop = 24;
        
    }
    ///标题不是空
    if (![NSString ht_isEmpty:self.title]) {
        titleHeight = [self.title ht_getHeightWithFontSize:self.titleLabel.font.pointSize width:contentWidth-MARGIN*2];
        titleHeight = MAX(18, titleHeight);
        //titleHeight = 18;
        messageTop = 16.5;
        self.titleLabel.hidden = NO;
        
    }else{
        
        //标题为空
        titleHeight = 0;
        titleTop = 0;
        
        if (imgHeight <= 1) {
            messageTop = 24;
        }else{
            messageTop = 16.5;
        }
        //        self.titleLabel.hidden = YES;
    }
    //message 内容
    if (![NSString ht_isEmpty:self.message]) {
        CGSize size = [self.message ht_sizeWithMaxWidth:contentWidth - MARGIN * 2 andFont:[UIFont systemFontOfSize:14]];
        messageHeight = MIN(size.height, [self ht_maxContentHeight]);
        self.messageLabel.hidden = NO;
        
    }else{
        
        messageHeight = 0;
        messageTop = 0;
        self.messageLabel.hidden = YES;
        
    }
    
    if (![NSString ht_isEmpty:self.cancelTitle] || ![NSString ht_isEmpty:self.confirmTitle] || ![NSString ht_isEmpty:self.centerTitle]) {
        //        contentWidth = [self maxContentWidth];
        ///左边按钮和右边按钮有一个不是空
        bottomViewHeight = 50;
        messageBottom = 24;
        
    }else{
        
        bottomViewHeight = 0;
        messageBottom = 24;
        
    }
    
    CGFloat bottomTextHeight = 0.0;
    if(self.var_bottomText){
        bottomTextHeight = 30.0f;
    }
    
    ///conent高度
    contentHeight = imgTop + imgHeight + titleTop + titleHeight + messageTop + messageHeight + messageBottom + bottomViewHeight + bottomTextHeight;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(contentHeight);
        make.width.mas_equalTo(contentWidth);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(imgTop);
        make.centerX.equalTo(self.contentView);
        make.width.height.mas_equalTo(imgHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.top.equalTo(self.imageView.mas_bottom).offset(titleTop);
        
        
        make.height.mas_equalTo(titleHeight);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(messageTop);
        make.left.equalTo(self.contentView).offset(MARGIN);
        make.right.equalTo(self.contentView).offset(-MARGIN);
        make.height.equalTo(@(messageHeight));
        //        make.width.equalTo(@(contentWidth - MARGIN * 2));
    }];
    
    if ([NSString ht_isEmpty:self.cancelTitle] && [NSString ht_isEmpty:self.confirmTitle] && [NSString ht_isEmpty:self.centerTitle]) {
        ///左边文字和右边文字都是空
        return;
    }else if (![NSString ht_isEmpty:self.cancelTitle] && ![NSString ht_isEmpty:self.confirmTitle]){
        ///左边文字和右边文字两个都不是空
        CGFloat cancelButtonH = [self.cancelTitle isEqualToString:@""] ? 0 : 50;
        CGFloat cancelButtonW = 0;
        CGFloat confirmButtonH = [self.confirmTitle isEqualToString:@""] ? 0 : 50;
        CGFloat confirmButtonW = 0;
        if (![self.cancelTitle isEqualToString:@""]) {
            cancelButtonW = [self.confirmTitle isEqualToString:@""] ? contentWidth : contentWidth * 0.5;
        }
        
        if (![self.confirmTitle isEqualToString:@""]) {
            confirmButtonW = [self.cancelTitle isEqualToString:@""] ? contentWidth : contentWidth * 0.5;
        }
        
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(cancelButtonW);
            make.height.mas_equalTo(cancelButtonH);
        }];
        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(confirmButtonW);
            make.height.mas_equalTo(confirmButtonH);
        }];
        
        //添加两条线
        if (![self.cancelTitle isEqualToString:@""] || ![self.confirmTitle isEqualToString:@""]) {
            UIView *line1 = [UIView new];
            line1.backgroundColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[[UIColor ht_colorWithHexString:@"#D9D9D9"] colorWithAlphaComponent:0.65] andDarkColor:[UIColor ht_colorWithHexString:@"#3C3C3D"]];
            [self.contentView addSubview:line1];
            [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.contentView).offset(-50);
                make.height.mas_equalTo(1);
                make.left.right.equalTo(self.contentView);
            }];
        }
        
        if (![self.cancelTitle isEqualToString:@""] && ![self.confirmTitle isEqualToString:@""]) {
            UIView *line2 = [UIView new];
            line2.backgroundColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[[UIColor ht_colorWithHexString:@"#D9D9D9"] colorWithAlphaComponent:0.65] andDarkColor:[UIColor ht_colorWithHexString:@"#3C3C3D"]];
            [self.contentView addSubview:line2];
            
            [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(50);
                make.width.mas_equalTo(1);
            }];
        }
        
    }else{
        ///只有一个按钮 那么只展示cancel btn
        ///左边文字和右边文字两个都不是空
        ///隐藏confirmbth
        CGFloat cancelButtonH =  bottomViewHeight;
        CGFloat cancelButtonW =  contentWidth;
        if (![NSString ht_isEmpty:self.cancelTitle]) {
            ///canceTitle为空
            [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.equalTo(self.contentView);
                make.width.mas_equalTo(cancelButtonW);
                make.height.mas_equalTo(cancelButtonH);
            }];
            
            //添加一条线
            if (![self.cancelTitle isEqualToString:@""] || ![self.confirmTitle isEqualToString:@""]) {
                UIView *line1 = [UIView new];
                line1.backgroundColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[[UIColor ht_colorWithHexString:@"#D9D9D9"] colorWithAlphaComponent:0.65] andDarkColor:[UIColor ht_colorWithHexString:@"#3C3C3D"]];
                [self.contentView addSubview:line1];
                [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.contentView).offset(-50);
                    make.height.mas_equalTo(1);
                    make.left.right.equalTo(self.contentView);
                }];
            }
        }else{
            if(![NSString ht_isEmpty:self.centerTitle] && self.var_bottomText){
                [self.var_centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.left.mas_equalTo(20);
                    make.height.mas_equalTo(cancelButtonH-10);
                }];
                self.var_centerButton.layer.cornerRadius = (cancelButtonH - 10)*0.5;
                self.var_centerButton.layer.masksToBounds = YES;
                [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.bottom.mas_equalTo(-10);
                    make.left.mas_equalTo(20);
                    make.height.mas_equalTo(30);
                    make.top.equalTo(self.var_centerButton.mas_bottom).inset(10);
                }];
            }else{
                [self.var_centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.bottom.mas_equalTo(-20);
                    make.left.mas_equalTo(20);
                    make.height.mas_equalTo(cancelButtonH-10);
                }];
                self.var_centerButton.layer.cornerRadius = (cancelButtonH - 10)*0.5;
                self.var_centerButton.layer.masksToBounds = YES;
            }
        }
    }
}

#pragma mark - 按钮事件
- (void)centerButtonClick{
    if(self.var_confirmClick){
        self.var_confirmClick(self);
    }
}

- (void)closeButtonClick{
    if(self.closeClick){
        self.closeClick(self);
    }
}

#pragma mark —— 获取字符串的宽度
- (CGFloat)ht_maxContentWidth
{
    return SCREEN_WIDTH - MARGIN * 2;
}

- (CGFloat)ht_minContentWidth
{
    return 170;
}

- (CGFloat)ht_maxContentHeight
{
    return SCREEN_HEIGHT * 0.5;;
}

- (void)removeSubviews
{
    if (self.subviews.count) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
}

- (void)cancelButtonClick
{
    if (self.cancelClick) {
        self.cancelClick(self);
    }
    
    [self dismiss];
}

- (void)confirmButtonClick
{
    if (self.var_confirmClick) {
        self.var_confirmClick(self);
    }
    
    [self dismiss];
}


#pragma mark - lazy
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor whiteColor] andDarkColor:[UIColor ht_colorWithHexString:@"#2D2D2E"]];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.adjustsFontSizeToFitWidth = YES;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [UILabel new];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.adjustsFontSizeToFitWidth = YES;
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.textColor = [UIColor whiteColor];
    }
    return _bottomLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        [_cancelButton setBackgroundColor:[[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor whiteColor] andDarkColor:[UIColor ht_colorWithHexString:@"#2D2D2E"]]];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton new];
        [_confirmButton setBackgroundColor:[[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor whiteColor] andDarkColor:[UIColor ht_colorWithHexString:@"#2D2D2E"]]];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UIButton *)var_centerButton
{
    if (!_var_centerButton) {
        _var_centerButton = [UIButton new];
        [_var_centerButton setBackgroundColor:[[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor whiteColor] andDarkColor:[UIColor ht_colorWithHexString:@"#2D2D2E"]]];
        [_var_centerButton addTarget:self action:@selector(centerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _var_centerButton;
}

- (UIButton *)var_closeButton
{
    if (!_var_closeButton) {
        _var_closeButton = [UIButton new];
        [_var_closeButton sd_setImageWithURL:kImageNumber(253) forState:UIControlStateNormal];
        [_var_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _var_closeButton;
}



@end
