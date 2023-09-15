//
//  ZKBasePopUpView.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/6/21.
//

#import "ZKBasePopUpView.h"
#import "ZKThemeAdapter.h"
#import "ZKBaseTextField.h"
#import "ZKPopUpViewBtnModel.h"

@interface ZKBasePopUpView () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, strong) ZKBaseTitleConfiguration *var_titleConfiguration;
@property (nonatomic, strong) ZKBaseMessageConfiguration *var_msgConfiguration;

@property (nonatomic, strong) NSMutableArray *var_textFields;
@property (nonatomic, strong) NSMutableArray *buttonModels;
@property (nonatomic, assign) ENUM_ZKBasePopUpViewStyle var_popUpViewStyle;
/// 分割线的颜色
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) NSNumber *canHideByClickBgView;  // 0 default, 1 YES, 2 NO;

@end

@implementation ZKBasePopUpView {
    CGFloat var_contentWidth;
    CGFloat var_contentHeight;
    
    NSInteger var_cancelBtnIndex;// 由于actionSheet的取消按钮需要单独添加，所以这里记录其下标
    BOOL var_hasAddCancelBtnForOnce;// 由于actionSheet样式的特殊性，其“取消”按钮只允许添加一次
}


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [[UIColor ht_colorWithHexString:@"#000000"] colorWithAlphaComponent:0.7];
        self.alpha = 0;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackGroundHide:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self ht_initializeUI];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    return [self initWithConfiguration:^(ZKBaseTitleConfiguration *var_titleConf) {
        var_titleConf.text = title;
    } andBaseMessageConfiguration:^(ZKBaseMessageConfiguration *var_msgConf) {
        var_msgConf.text = message;
    }];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles action:(void(^)(NSInteger index))action {
    ZKBasePopUpView *var_popUpView = [self initWithConfiguration:^(ZKBaseTitleConfiguration *var_titleConf) {
        var_titleConf.text = title;
    } andBaseMessageConfiguration:^(ZKBaseMessageConfiguration *var_msgConf) {
        var_msgConf.text = message;
    }];
    
    if (otherButtonTitles && otherButtonTitles.count) {
        for (int i = 0; i < otherButtonTitles.count; i ++) {
            NSString *var_btnTitle = otherButtonTitles[i];
            if (var_btnTitle && var_btnTitle.length) {
                [var_popUpView addBtnWithTitle:var_btnTitle type:ENUM_ZKBasePopUpBtnStyleDefault handler:^{
                    if (action) action(i+1);
                }];
            }
        }
    }
    
    if (cancelButtonTitle && cancelButtonTitle.length) {
        [var_popUpView addBtnWithTitle:cancelButtonTitle type:ENUM_ZKBasePopUpBtnStyleCancel handler:^{
            if (action) action(0);
        }];
    }
    return var_popUpView;
}

-(instancetype)initWithConfiguration:(void (^)(ZKBaseTitleConfiguration *configuration))var_baseTitleConfiguration andBaseMessageConfiguration:(void (^)(ZKBaseMessageConfiguration *configuration))var_baseMsgConfiguration {
    self = [self init];
    if (self) {
        if (var_baseTitleConfiguration) {
            var_baseTitleConfiguration(_var_titleConfiguration);
            if (!_var_titleConfiguration.text || !_var_titleConfiguration.text.length) _var_titleConfiguration = nil;
        }else {
            _var_titleConfiguration = nil;
        }
        
        if (var_baseMsgConfiguration) {
            var_baseMsgConfiguration(_var_msgConfiguration);
            if (!_var_msgConfiguration.text || !_var_msgConfiguration.text.length) _var_msgConfiguration = nil;
        }else {
            _var_msgConfiguration = nil;
        }
    }
    return self;
}


- (void)ht_initializeUI {
    [self ht_valueInitialize];
    [self ht_setUpContentView];
    [self ht_setUpTitleLabel];
    [self ht_setUpMessageLabel];
}

- (void)ht_valueInitialize {
    _canHideByClickBgView = @(0);
    var_contentWidth = 265;
    _textFieldFontSize = 15.0;
    _btnStyleDefaultTextColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#0a7af3"] andDarkColor:[UIColor ht_colorWithHexString:@"#2D2D2E"]];
    _btnStyleCancelTextColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#999999"] andDarkColor:[UIColor ht_colorWithHexString:@"#2D2D2E"]];
    _btnStyleDestructiveTextColor = [UIColor ht_colorWithHexString:@"#ff4141"];
    _textFieldHeight = 33.0;
    self.buttonHeight = 48.0;
    _var_lineHeight = 0.5;
    _var_textFields = [NSMutableArray array];
    _buttonModels = [NSMutableArray array];
    
    _var_titleConfiguration = [ZKBaseTitleConfiguration new];
    _var_titleConfiguration.fontSize = 18.0;
    _var_titleConfiguration.textColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#000000"] andDarkColor:[UIColor ht_colorWithHexString:@"#E0E0E0"]];
    _var_titleConfiguration.top = 15;
    
    _var_msgConfiguration = [ZKBaseMessageConfiguration new];
    _var_msgConfiguration.fontSize = 16.0;
    _var_msgConfiguration.textColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#333333"] andDarkColor:[UIColor ht_colorWithHexString:@"#E0E0E0"]];
    _var_msgConfiguration.top = 10;
    _var_msgConfiguration.bottom = 15;
}

- (void)ht_setUpContentView {
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#2E3137"] andDarkColor:[UIColor ht_colorWithHexString:@"#2E3137"]];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = SCREEN_HEIGHT/71.0;
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    _contentView = contentView;
}

- (void)ht_setUpTitleLabel {
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)ht_setUpMessageLabel {
    UILabel *messageLabel = [UILabel new];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:messageLabel];
    _messageLabel = messageLabel;
}

- (void)addTextFieldWithPlaceholder:(NSString *)placeholder text:(NSString *)text secureEntry:(BOOL)secureEntry {
    ZKBaseTextField *tf = [[ZKBaseTextField alloc] init];
    tf.var_textNumber = 30;
    tf.text = text;
    tf.placeholder = placeholder;
    tf.textColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#333333"] andDarkColor:[UIColor ht_colorWithHexString:@"#E0E0E0"]];
    tf.font = [UIFont systemFontOfSize:_textFieldFontSize];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.secureTextEntry = secureEntry;
    [_var_textFields addObject:tf];
}

-(void)addBtnWithTitle:(NSString *)title type:(ENUM_ZKBasePopUpBtnStyle)style handler:(BLOCK_buttonActionBlock)handler {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000+_buttonModels.count;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[self colorWithBtnStyle:style] forState:UIControlStateNormal];
    button.titleLabel.font = style == ENUM_ZKBasePopUpBtnStyleCancel ? [UIFont systemFontOfSize:16] : [UIFont boldSystemFontOfSize:16];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:button];
    
    ZKPopUpViewBtnModel *var_btnModel = [ZKPopUpViewBtnModel new];
    var_btnModel.button = button;
    var_btnModel.buttonStyle = style;
    var_btnModel.actionHandler = handler;
    [_buttonModels addObject:var_btnModel];
}

- (void)addBtnWithTitle:(NSString *)title isNeedCountDown:(BOOL)countDown type:(ENUM_ZKBasePopUpBtnStyle)style handler:(BLOCK_buttonActionBlock)handler{
    self.second = 5;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000+_buttonModels.count;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[self colorWithBtnStyle:style] forState:UIControlStateNormal];
    button.titleLabel.font = style == ENUM_ZKBasePopUpBtnStyleCancel ? [UIFont systemFontOfSize:16] : [UIFont boldSystemFontOfSize:16];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:button];
    
    self.countDownBtn = button;
    self.countDownBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    ZKPopUpViewBtnModel *var_btnModel = [ZKPopUpViewBtnModel new];
    var_btnModel.button = self.countDownBtn;
    var_btnModel.buttonStyle = style;
    var_btnModel.actionHandler = handler;
    [_buttonModels addObject:var_btnModel];
    [self startCountDown];
}

- (void)startCountDown {
    //(1)
    dispatch_queue_t var_quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //(2)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, var_quene);
    //(3)
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //(4)
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (self.second == 0) {
                self.second = 5;
                //(6)
                if (self) {
                    dispatch_cancel(self.timer);
                }
                self.countDownBtn.enabled = YES;
                [self.countDownBtn setTitle:[NSString stringWithFormat:@"%@", AsciiString(@"i have learned")] forState:0];
                self.countDownBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                [self.countDownBtn setTitleColor:[UIColor ht_colorWithHexString:@"#4974F5"] forState:0];
            } else {
                self.second--;
                if (self.second == 0) {
                    self.countDownBtn.enabled = YES;
                    [self.countDownBtn setTitle:[NSString stringWithFormat:@"%@", AsciiString(@"i have learned")] forState:0];
                    self.countDownBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                    [self.countDownBtn setTitleColor:[UIColor ht_colorWithHexString:@"#4974F5"] forState:0];
                }else{
                    self.countDownBtn.enabled = NO;
                    self.countDownBtn.titleLabel.font = [UIFont systemFontOfSize:16];
                    [self.countDownBtn setTitle:[NSString stringWithFormat:@"%@ %lds", AsciiString(@"i have learned"), self.second] forState:0];
                    [self.countDownBtn setTitleColor:[UIColor ht_colorWithHexString:@"#999999"] forState:0];
                }
            }
        });
    });
    //(5)
    dispatch_resume(self.timer);
}


- (void)ht_configureAndLayoutTitleLabel {
    if (_var_titleConfiguration) {
        CGFloat var_leftPadding = 23.5;
        CGFloat var_labelWidth = var_contentWidth - var_leftPadding * 2;
        _titleLabel.text = _var_titleConfiguration.text;
        _titleLabel.textColor = _var_titleConfiguration.textColor;
        _titleLabel.font = [UIFont systemFontOfSize:_var_titleConfiguration.fontSize weight:UIFontWeightBold];
        [self fixTopAndBottomValues];
        CGFloat top = _var_titleConfiguration.top;
        CGSize var_titleSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(var_labelWidth, 250) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _titleLabel.font} context:nil].size;
        _titleLabel.frame = CGRectMake(var_leftPadding, top, var_labelWidth, var_titleSize.height);
    }
}

- (void)ht_configureAndLayoutMsgLabel {
    if (_var_msgConfiguration) {
        CGFloat var_leftPadding = 23.5;
        CGFloat var_labelWidth = var_contentWidth - var_leftPadding * 2;
        _messageLabel.text = _var_msgConfiguration.text;
        _messageLabel.textColor = _var_msgConfiguration.textColor;
        _messageLabel.font = [UIFont systemFontOfSize:_var_msgConfiguration.fontSize];
        [self fixTopAndBottomValues];
        CGFloat top = CGRectGetMaxY(_titleLabel.frame) + _var_titleConfiguration.bottom + _var_msgConfiguration.top;
        CGSize size = [_messageLabel.text boundingRectWithSize:CGSizeMake(var_labelWidth, 250) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _messageLabel.font} context:nil].size;
        _messageLabel.frame = CGRectMake(var_leftPadding, top, var_labelWidth, size.height);
    }
}

- (void)ht_layoutTextFields {
    if (!_var_textFields.count) return;
    if (_var_popUpViewStyle == ENUM_ZKBasePopUpViewStyleAlert) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ht_keyboard_willShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ht_keyboard_willHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    _textFieldArray = _var_textFields.copy;
    CGFloat var_tfPadding = 20;
    UIView *var_textFieldBgView = [UIView new];
    var_textFieldBgView.layer.masksToBounds = YES;
    var_textFieldBgView.layer.cornerRadius = 4;
    var_textFieldBgView.layer.borderWidth = 0.8;
    var_textFieldBgView.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
    [_contentView addSubview:var_textFieldBgView];
    CGFloat var_baseTop = [self ht_getTitleAndMsgLabelBaseHeight];
    for (int i = 0; i < _var_textFields.count; i ++) {
        // Line 横线
        if (i >= 1) {
            CALayer *var_lineLayer = [CALayer layer];
            var_lineLayer.backgroundColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
            CGFloat top = _textFieldHeight +(_textFieldHeight+_var_lineHeight)*(i-1);
            var_lineLayer.frame = CGRectMake(0, top, var_contentWidth-(2*var_tfPadding), _var_lineHeight);
            [var_textFieldBgView.layer addSublayer:var_lineLayer];
        }
        
        UITextField *tf = _var_textFields[i];
        tf.frame = CGRectMake(5, (_textFieldHeight+_var_lineHeight)*i, var_contentWidth-(2*var_tfPadding)-10, _textFieldHeight);
        [var_textFieldBgView addSubview:tf];
    }
    UITextField *var_lastTf = _var_textFields.lastObject;
    var_textFieldBgView.frame = CGRectMake(var_tfPadding, var_baseTop, var_contentWidth-(2*var_tfPadding), CGRectGetMaxY(var_lastTf.frame));
    
    _contentView.frame = CGRectMake(10, SCREEN_HEIGHT, var_contentWidth, CGRectGetMaxY(var_textFieldBgView.frame) + 15.0);
    var_contentHeight = CGRectGetMaxY(var_textFieldBgView.frame) + 15.0;
}

- (void)ht_layoutButtons {
    if (_var_popUpViewStyle == ENUM_ZKBasePopUpViewStyleAlert) {
        [self layoutBtnsForAlert];
    }else if (_var_popUpViewStyle == ENUM_ZKBasePopUpViewStyleActionSheet) {
        [self layoutBtnsForActionSheet];
    }
}

- (void)layoutBtnsForAlert {
    if (_buttonModels.count == 2) {
        // Line 横线
        CALayer *var_lineLayer = [CALayer layer];
        var_lineLayer.backgroundColor = [self.lineColor CGColor];
        CGFloat top = [self ht_getTitleAndMsgLabelBaseHeight];
        if (_var_textFields.count) {
            NSInteger var_tfCount = _var_textFields.count;
            top += (var_tfCount*_textFieldHeight + (var_tfCount-1)*_var_lineHeight + 15.0);
        }
        var_lineLayer.frame = CGRectMake(0, top, var_contentWidth, _var_lineHeight);
        [_contentView.layer addSublayer:var_lineLayer];
        //竖线
        CALayer *var_lineLayer2 = [CALayer layer];
        var_lineLayer2.backgroundColor = [self.lineColor CGColor];
        var_lineLayer2.frame = CGRectMake(var_contentWidth/2.0, top+_var_lineHeight, _var_lineHeight, self.buttonHeight);
        [_contentView.layer addSublayer:var_lineLayer2];
        
        for (int i = 0; i < _buttonModels.count; i ++) {
            ZKPopUpViewBtnModel *var_btnModel = _buttonModels[i];
            UIButton *button = var_btnModel.button;
            [button setTitleColor:[self colorWithBtnStyle:var_btnModel.buttonStyle] forState:UIControlStateNormal];
            button.frame = CGRectMake(var_contentWidth/2.0*i, top+_var_lineHeight, var_contentWidth/2.0, self.buttonHeight);
        }
        _contentView.frame = CGRectMake(10, SCREEN_HEIGHT, var_contentWidth, top+_var_lineHeight+self.buttonHeight);
        var_contentHeight = _contentView.frame.size.height;
    }else if (_buttonModels.count == 1 || _buttonModels.count >= 3) {
        CGFloat var_baseTop = [self ht_getTitleAndMsgLabelBaseHeight];
        if (_var_textFields.count) {
            NSInteger var_tfCount = _var_textFields.count;
            var_baseTop += (var_tfCount*_textFieldHeight + (var_tfCount-1)*_var_lineHeight + 15.0);
        }
        //要确保“取消”按钮在最下面
        NSInteger offset = 0;
        NSInteger var_nonCancelBtnCount = 0;// 用于计算非取消按钮的个数及总高度
        for (int i = 0; i < _buttonModels.count; i ++) {
            ZKPopUpViewBtnModel *var_btnModel = _buttonModels[i];
            if (var_btnModel.buttonStyle == ENUM_ZKBasePopUpBtnStyleCancel) {
                offset --;
                continue;
            }
            var_nonCancelBtnCount ++;
            CGFloat top = var_baseTop;
            NSInteger index = i + offset;
            
            // Line 横线
            CALayer *var_lineLayer = [CALayer layer];
            var_lineLayer.backgroundColor = [self.lineColor CGColor];
            top += ((_var_lineHeight+self.buttonHeight)*index);
            var_lineLayer.frame = CGRectMake(0, top, var_contentWidth, _var_lineHeight);
            [_contentView.layer addSublayer:var_lineLayer];
            
            UIButton *button = var_btnModel.button;
            [button setTitleColor:[self colorWithBtnStyle:var_btnModel.buttonStyle] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, top+_var_lineHeight, var_contentWidth, self.buttonHeight);
        }
        
        //添加取消按钮
        CGFloat var_baseTop2 = var_baseTop + (_var_lineHeight+self.buttonHeight) * var_nonCancelBtnCount;
        NSInteger index = 0;
        for (int i = 0; i < _buttonModels.count; i ++) {
            ZKPopUpViewBtnModel *var_btnModel = _buttonModels[i];
            if (var_btnModel.buttonStyle == ENUM_ZKBasePopUpBtnStyleCancel) {
                CGFloat top = var_baseTop2;
                
                // Line 横线
                CALayer *var_lineLayer = [CALayer layer];
                var_lineLayer.backgroundColor = [self.lineColor CGColor];
                top += ((_var_lineHeight+self.buttonHeight)*index);
                var_lineLayer.frame = CGRectMake(0, top, var_contentWidth, _var_lineHeight);
                [_contentView.layer addSublayer:var_lineLayer];
                
                UIButton *button = var_btnModel.button;
                [button setTitleColor:[self colorWithBtnStyle:var_btnModel.buttonStyle] forState:UIControlStateNormal];
                button.frame = CGRectMake(0, top+_var_lineHeight, var_contentWidth, self.buttonHeight);
                index ++;
            }
        }
        _contentView.frame = CGRectMake(10, SCREEN_HEIGHT, var_contentWidth, var_baseTop+(_var_lineHeight+self.buttonHeight)*_buttonModels.count);
        var_contentHeight = _contentView.frame.size.height;
    }
}

- (void)layoutBtnsForActionSheet {
    CGFloat var_baseTop = [self ht_getTitleAndMsgLabelBaseHeight];
    if (_var_textFields.count) {
        NSInteger var_tfCount = _var_textFields.count;
        var_baseTop += (var_tfCount*_textFieldHeight + (var_tfCount-1)*_var_lineHeight + 15.0);
    }
    
    //要确保“取消”按钮在最下面
    NSInteger offset = 0;
    var_cancelBtnIndex = 0;
    for (int i = 0; i < _buttonModels.count; i ++) {
        ZKPopUpViewBtnModel *var_btnModel = _buttonModels[i];
        if (var_btnModel.buttonStyle == ENUM_ZKBasePopUpBtnStyleCancel) {
            if (var_hasAddCancelBtnForOnce) {
                return;
            }else {
                var_hasAddCancelBtnForOnce = YES;
            }
            
            offset = -1;
            var_cancelBtnIndex = i;
            continue;
        }
        
        CGFloat top = var_baseTop;
        NSInteger index = i + offset;
        // Line 横线
        CALayer *var_lineLayer = [CALayer layer];
        var_lineLayer.backgroundColor = [self.lineColor CGColor];
        top += ((_var_lineHeight+self.buttonHeight)*index);
        var_lineLayer.frame = CGRectMake(0, top, var_contentWidth, _var_lineHeight);
        [_contentView.layer addSublayer:var_lineLayer];
        
        UIButton *button = var_btnModel.button;
        [button setTitleColor:[self colorWithBtnStyle:var_btnModel.buttonStyle] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, top+_var_lineHeight, var_contentWidth, self.buttonHeight);
    }
    
    //计算contentView的frame
    if (var_hasAddCancelBtnForOnce) {
        _contentView.frame = CGRectMake(10, SCREEN_HEIGHT, var_contentWidth, var_baseTop + (_var_lineHeight + self.buttonHeight) * (_buttonModels.count - 1));
    } else {
        _contentView.frame = CGRectMake(10, SCREEN_HEIGHT, var_contentWidth, var_baseTop + (_var_lineHeight + self.buttonHeight) * _buttonModels.count);
    }
    
    //添加取消按钮
    if (var_hasAddCancelBtnForOnce) {
        ZKPopUpViewBtnModel *var_cancelBtnModel = _buttonModels[var_cancelBtnIndex];
        UIButton *button = var_cancelBtnModel.button;
        [button setTitleColor:[self colorWithBtnStyle:var_cancelBtnModel.buttonStyle] forState:UIControlStateNormal];
        CGFloat var_cancelBtnTop = SCREEN_HEIGHT + _contentView.bounds.size.height + 10 + self.buttonHeight + 10;
        button.frame = CGRectMake(10, var_cancelBtnTop, var_contentWidth, self.buttonHeight);
        button.layer.masksToBounds = YES;
        button.backgroundColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor whiteColor] andDarkColor:[UIColor ht_colorWithHexString:@"#2D2D2E"]];
        button.layer.cornerRadius = _contentView.layer.cornerRadius;
        [button removeFromSuperview];
        [self addSubview:button];
    }
}

- (void)fixTopAndBottomValues {
    if (_var_titleConfiguration) {
        if (_var_msgConfiguration) {
            if (_var_msgConfiguration.bottom == 0) {
                _var_msgConfiguration.bottom = 15.0;
            }
        }else {
            if (_var_titleConfiguration.bottom == 0) {
                _var_titleConfiguration.bottom = 15.0;
            }
        }
    }else {
        if (_var_msgConfiguration) {
            if (_var_msgConfiguration.top < 15.0) {
                _var_msgConfiguration.top = 15.0;
            }
            if (_var_msgConfiguration.bottom == 0) {
                _var_msgConfiguration.bottom = 15.0;
            }
        }else {
        }
    }
}

- (CGFloat)ht_getTitleAndMsgLabelBaseHeight {
    CGFloat height = 0;
    if (_var_msgConfiguration) {
        height = CGRectGetMaxY(_messageLabel.frame) + _var_msgConfiguration.bottom;
    }else {
        if (_var_titleConfiguration) {
            height = CGRectGetMaxY(_titleLabel.frame) + _var_titleConfiguration.bottom;
        }else {
            height = 15.0;
        }
    }
    return height;
}

- (UIColor *)colorWithBtnStyle:(ENUM_ZKBasePopUpBtnStyle)style {
    if (style == ENUM_ZKBasePopUpBtnStyleDefault) {
        return _btnStyleDefaultTextColor;
    }else if (style == ENUM_ZKBasePopUpBtnStyleCancel) {
        return _btnStyleCancelTextColor;
    }else if (style == ENUM_ZKBasePopUpBtnStyleDestructive) {
        return _btnStyleDestructiveTextColor;
    }
    return nil;
}

-(void)showInWindowWithPreferredStyle:(ENUM_ZKBasePopUpViewStyle)preferredStyle {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self showInView:window preferredStyle:preferredStyle];
}

-(void)showInView:(UIView *)view preferredStyle:(ENUM_ZKBasePopUpViewStyle)preferredStyle {
    
    ZKBasePopUpView *var_laseView = [view viewWithTag:318400];
    if (var_laseView) {
        [var_laseView ht_hide];
    }
    
    self.tag = 318400;
    
    _var_popUpViewStyle = preferredStyle;
    if (preferredStyle == ENUM_ZKBasePopUpViewStyleAlert) {
        var_contentWidth = 270;
        [view addSubview:self];
        _contentView.center = self.center;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        }];
        [self showAlertAnimation];
    }else if (preferredStyle == ENUM_ZKBasePopUpViewStyleActionSheet) {
        var_contentWidth = SCREEN_WIDTH - 10 - 10;
        [view addSubview:self];
        [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect rect = self.contentView.frame;
            CGFloat offset = self->var_hasAddCancelBtnForOnce ? self.buttonHeight+10 : 0;
            rect.origin.y = SCREEN_HEIGHT - rect.size.height - 10 - offset;
            self.contentView.frame = rect;
            
            //取消按钮的动画
            if (self->var_hasAddCancelBtnForOnce) {
                ZKPopUpViewBtnModel *var_cancelBtnModel = self.buttonModels[self->var_cancelBtnIndex];
                UIButton *button = var_cancelBtnModel.button;
                CGRect rect = button.frame;
                rect.origin.y = SCREEN_HEIGHT - rect.size.height - 10;
                button.frame = rect;
            }
            
            self.alpha = 1.0;
        } completion:nil];
    }
}

-(void)didMoveToSuperview {
    if (self.superview) {
        [self ht_configureAndLayoutTitleLabel];
        [self ht_configureAndLayoutMsgLabel];
        [self ht_layoutTextFields];
        [self ht_layoutButtons];
    }
}

- (void)showAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [_contentView.layer addAnimation:animation forKey:AsciiString(@"showAlert")];
}

- (void)dismissAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [_contentView.layer addAnimation:animation forKey:AsciiString(@"dismissAlert")];
}

- (void)ht_hide {
    if (_var_popUpViewStyle == ENUM_ZKBasePopUpViewStyleAlert) {
        [self dismissAlertAnimation];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else if(_var_popUpViewStyle == ENUM_ZKBasePopUpViewStyleActionSheet) {
        [UIView animateWithDuration:0.24 delay:0.08 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
            
            CGRect rect = self.contentView.frame;
            rect.origin.y = SCREEN_HEIGHT;
            self.contentView.frame = rect;
            if (self->var_hasAddCancelBtnForOnce) {
                ZKPopUpViewBtnModel *var_cancelBtnModel = self.buttonModels[self->var_cancelBtnIndex];
                UIButton *button = var_cancelBtnModel.button;
                CGRect rect = button.frame;
                rect.origin.y = SCREEN_HEIGHT + 10 + self.buttonHeight + 10;
                button.frame = rect;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)btnAction:(UIButton *)sender {
    NSInteger index = sender.tag-1000;
    
    ZKPopUpViewBtnModel *model = _buttonModels[index];
    BLOCK_buttonActionBlock handler = model.actionHandler;
    if (handler) handler();
    [self ht_hide];
}

- (void)clickBackGroundHide:(UITapGestureRecognizer *)tap {
    if (_canHideByClickBgView.integerValue == 0) {// 用户没有设置过 self.canClickBackgroundHide 的值，按默认处理
        if (_var_popUpViewStyle == ENUM_ZKBasePopUpViewStyleAlert) {
        }else if (_var_popUpViewStyle == ENUM_ZKBasePopUpViewStyleActionSheet) {
            [self ht_hide];
        }
    }else if (_canHideByClickBgView.integerValue == 1) {// YES
        [self ht_hide];
    }else if (_canHideByClickBgView.integerValue == 2) {// NO
    }
}

- (void)backgroundColorForButton:(id)sender {
    [sender setBackgroundColor:[[UIColor ht_colorWithHexString:@"#cccccc"] colorWithAlphaComponent:0.8]];
}

- (void)clearBackgroundColorForButton:(UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    if (index == var_cancelBtnIndex) {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }else {
        [sender setBackgroundColor:[UIColor clearColor]];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_contentView.frame, point)) {
        return NO;
    }
    return YES;
}

-(void)setCanClickBackgroundHide:(BOOL)canClickBackgroundHide {
    _canHideByClickBgView = canClickBackgroundHide ? @(1) : @(2);
}

-(void)ht_keyboard_willShow:(NSNotification *)ntf {
    NSDictionary * userInfo = [ntf userInfo];
    CGFloat duration = [userInfo[AsciiString(@"UIKeyboardAnimationDurationUserInfoKey")] floatValue];
    CGRect var_kbRect = [userInfo[AsciiString(@"UIKeyboardBoundsUserInfoKey")] CGRectValue];
    CGFloat var_kbMinY = SCREEN_HEIGHT - CGRectGetHeight(var_kbRect);
    
    CGRect var_beginUserInfo = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if (var_beginUserInfo.size.height <=0) {
        //!!搜狗输入法弹出时会发出三次UIKeyboardWillShowNotification的通知,和官方输入法相比,有效的一次为UIKeyboardFrameBeginUserInfoKey.size.height都大于零时.
        return;
    }
    
    CGFloat var_contentView_maxY = CGRectGetMaxY(_contentView.frame)+(5); //+5让输入框再高于键盘5的高度
    CGFloat offset = var_contentView_maxY - var_kbMinY;
    if (offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            CGRect rect = self.contentView.frame;
            rect.origin.y -= offset;
            self.contentView.frame = rect;
        }];
    }
}

-(void)ht_keyboard_willHide:(NSNotification *)ntf {
    NSDictionary * userInfo = [ntf userInfo];
    CGFloat duration = [userInfo[AsciiString(@"UIKeyboardAnimationDurationUserInfoKey")] floatValue];
    @weakify(self);
    [UIView animateWithDuration:duration animations:^{
        @strongify(self);
        self.contentView.center = self.center;
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIColor *)lineColor{
    if (!_lineColor) {
        _lineColor = [[ZKThemeAdapter shareInstance] ht_dynamicColor:[UIColor ht_colorWithHexString:@"#37383C"] andDarkColor:[UIColor ht_colorWithHexString:@"#37383C"]];
    }
    return _lineColor;
}

@end
