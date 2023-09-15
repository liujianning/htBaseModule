//
//  ZKBasePopUpView.h
//  ZKBaseUIKit
//
//  Created by Apple on 2022/6/21.
//

#import <UIKit/UIKit.h>
#import "ZKBaseMessageConfiguration.h"
#import "ZKBaseTitleConfiguration.h"

typedef NS_ENUM(NSUInteger, ENUM_ZKBasePopUpBtnStyle) {
        ENUM_ZKBasePopUpBtnStyleDefault = 0,
        ENUM_ZKBasePopUpBtnStyleCancel = 1,
        ENUM_ZKBasePopUpBtnStyleDestructive = 2,
};

typedef NS_ENUM(NSUInteger, ENUM_ZKBasePopUpViewStyle) {
        ENUM_ZKBasePopUpViewStyleAlert = 0,
        ENUM_ZKBasePopUpViewStyleActionSheet = 1
};


typedef void(^BLOCK_buttonActionBlock) (void);

@interface ZKBasePopUpView : UIView

// you can get textField's text from this property
@property (nonatomic, strong, readonly) NSArray *textFieldArray;

// customize property

// default 50.0
@property (nonatomic, assign) CGFloat buttonHeight;

// default 33.0
@property (nonatomic, assign) CGFloat textFieldHeight;

// default 0.6
@property (nonatomic, assign) CGFloat var_lineHeight;

// default 15.0
@property (nonatomic, assign) CGFloat textFieldFontSize;

// default 0x0a7af3, system alert blue
@property (nonatomic, strong) UIColor *btnStyleDefaultTextColor;

// default 0x555555, black
@property (nonatomic, strong) UIColor *btnStyleCancelTextColor;

// default 0xff4141, red
@property (nonatomic, strong) UIColor *btnStyleDestructiveTextColor;

// default when preferredStyle is ZKBasePopUpViewStyleAlert NO, when preferredStyle is ZKBasePopUpViewStyleActionSheet YES
@property (nonatomic, assign) BOOL canClickBackgroundHide;

@property (assign, nonatomic) NSInteger second;
@property (strong, nonatomic) dispatch_source_t timer;
@property (nonatomic, strong) UIButton *countDownBtn;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles action:(void(^)(NSInteger index))action;

- (instancetype)initWithConfiguration:(void (^)(ZKBaseTitleConfiguration *configuration))var_baseTitleConfiguration andBaseMessageConfiguration:(void (^)(ZKBaseMessageConfiguration *configuration))var_baseMsgConfiguration;

- (void)addBtnWithTitle:(NSString *)title type:(ENUM_ZKBasePopUpBtnStyle)style handler:(BLOCK_buttonActionBlock)handler;

- (void)addBtnWithTitle:(NSString *)title isNeedCountDown:(BOOL)countDown type:(ENUM_ZKBasePopUpBtnStyle)style handler:(BLOCK_buttonActionBlock)handler;

- (void)addTextFieldWithPlaceholder:(NSString *)placeholder text:(NSString *)text secureEntry:(BOOL)secureEntry;

//show
- (void)showInWindowWithPreferredStyle:(ENUM_ZKBasePopUpViewStyle)preferredStyle;

- (void)showInView:(UIView *)view preferredStyle:(ENUM_ZKBasePopUpViewStyle)preferredStyle;


@end
