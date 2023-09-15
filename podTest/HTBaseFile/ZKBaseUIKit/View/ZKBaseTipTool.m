//
//  ZKBaseTipTool.m
//  ZKBaseUIKit
//
//  Created by Apple on 2022/5/30.
//

#import "ZKBaseTipTool.h"
#import <Toast/Toast.h>

@interface ZKBaseTipTool ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) CSToastStyle *toastStyle;
@property (nonatomic, strong) UIView *backView;
@end

@implementation ZKBaseTipTool

+ (instancetype)sharedInstance{
    static ZKBaseTipTool *var_tipToolCore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        var_tipToolCore = [[ZKBaseTipTool alloc] init];
    });
    return var_tipToolCore;
}

- (instancetype)init{
    self = [super init];
    if(self){
        CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
        toastStyle.backgroundColor = [UIColor grayColor];
        toastStyle.messageColor = [UIColor whiteColor];

        self.toastStyle = toastStyle;
    }
    return self;
}

- (UIView *)backView{
    if(!_backView){
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [[UIColor ht_colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackGroundHide:)];
        tap.delegate = self;
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}

- (void)clickBackGroundHide:(UITapGestureRecognizer *)sender{
    
}

+ (void)showLoadingTip{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:[ZKBaseTipTool sharedInstance].backView];
    [[ZKBaseTipTool sharedInstance].backView makeToastActivity:CSToastPositionCenter];
}

+ (void)hideAllLoadingTip{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window hideToastActivity];
    [window hideAllToasts];
    [[ZKBaseTipTool sharedInstance].backView hideToastActivity];
    [[ZKBaseTipTool sharedInstance].backView hideAllToasts];
    [[ZKBaseTipTool sharedInstance].backView removeFromSuperview];
}

+ (void)lgjeropj_showDotLoadingTipWithText:(NSString *)text{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake((120-10*4-10*(4-1))*0.5, 30, 10, 10);
    layer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 10, 10)].CGPath;
    layer.fillColor = [UIColor orangeColor].CGColor;
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform"];
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0)];
    scale.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0)];
    scale.autoreverses = YES;
    scale.duration = 0.5;
    scale.repeatCount = HUGE;
    [layer addAnimation:scale forKey:@"scaleAnimation"];
    
    CAReplicatorLayer *Rlayer = [CAReplicatorLayer layer];
    Rlayer.instanceDelay = 0.2;
    Rlayer.instanceCount = 4;
    Rlayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0); //每复制一个块向右移动
    Rlayer.frame = CGRectMake(0, 0, 10, 10);
    [Rlayer addSublayer:layer];
    
    UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    subView.tag = 3032213;
    subView.layer.cornerRadius = 10.0f;
    subView.layer.masksToBounds = YES;
    subView.center = CGPointMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.5);
    subView.backgroundColor = [UIColor whiteColor];
    [subView.layer addSublayer:Rlayer];
    if(![NSString ht_isEmpty:text]){
        UILabel *labelText = [[UILabel alloc] initWithFrame:CGRectMake(0, 120-30-20, 120, 30)];
        if (@available(iOS 8.2, *)) {
            labelText.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightMedium];
        } else {
            labelText.font = [UIFont boldSystemFontOfSize:14.0f];
        }
        labelText.textAlignment = NSTextAlignmentCenter;
        labelText.text = kFormat(text).ht_isEmptyStr;
        labelText.textColor = [UIColor ht_colorWithHexString:@"#FF9C36"];
        [subView addSubview:labelText];
    }
    [[ZKBaseTipTool sharedInstance].backView addSubview:subView];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:[ZKBaseTipTool sharedInstance].backView];
}

+ (void)ht_showIconMessage:(NSString *)message andIcon:(NSURL *)image duration:(NSTimeInterval)duration{
    CGFloat width = 120.0f;
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-width)*0.5, (SCREEN_HEIGHT-width)*0.55, width, width)];
    backGroundView.layer.cornerRadius = 5.0f;
    backGroundView.layer.masksToBounds = YES;
    backGroundView.backgroundColor = [UIColor ht_colorWithHexString:@"#313143"];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:image];
    imageView.frame = CGRectMake((width - 35) * 0.5, 15, 35, 35);
    [backGroundView addSubview:imageView];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 5, width - 20, width - CGRectGetMaxY(imageView.frame) - 20)];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.text = message;
    [backGroundView addSubview:contentLabel];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window showToast:backGroundView duration:duration position:CSToastPositionCenter completion:^(BOOL didTap) {}];
}

+ (void)ht_hideDotLoadingTip{
    UIView *subView = [[ZKBaseTipTool sharedInstance].backView viewWithTag:3032213];
    if(subView.superview){
        [subView removeFromSuperview];
    }
    [[ZKBaseTipTool sharedInstance].backView removeFromSuperview];
}

+ (void)showMessage:(NSString *)message{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self showMessage:message toView:window];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view{
    [view makeToast:message duration:2.0 position:CSToastPositionCenter style:[ZKBaseTipTool sharedInstance].toastStyle];
}

+(void)show:(UIAlertController*)vc{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];;
    UIViewController *control = window.rootViewController.presentedViewController;
    if (control) {
        while (1) {
            UIViewController *newControl = [ZKBaseTipTool ht_getViewController:control];
            if (newControl) {
                control = newControl;
            }else{
                break;
            }
        }
        [control presentViewController:vc animated:YES completion:nil];
    } else {
        [window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}

+(UIViewController *)ht_getViewController:(UIViewController *)control{
    return control.presentedViewController;
}

@end
