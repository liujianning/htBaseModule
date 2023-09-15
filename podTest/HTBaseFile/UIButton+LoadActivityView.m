//
//  UIButton+LoadActivityView.m
//  LoadActivityIndicatorButton
//
//  Created by Apple on 22/7/21.
//  Copyright (c) 2022年 Apple. All rights reserved.
//

#import "UIButton+LoadActivityView.h"

static NSUInteger const STATIC_indicatorViewSize = 20;
static NSUInteger const STATIC_indicatorViewTag  = 999;

@implementation UIButton (LoadActivityView)

- (void)lgjeropj_startButtonActivityIndicatorView
{
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.4];
    self.enabled = NO;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  
    CGRect rect = [self.currentTitle boundingRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:self.titleLabel.font} context:nil];
    CGSize p = CGRectIntegral(rect).size;
    
    
    indicatorView.frame = CGRectMake(self.bounds.size.width/2 + p.width/2 + STATIC_indicatorViewSize, self.bounds.size.height/2 - STATIC_indicatorViewSize/2, STATIC_indicatorViewSize, STATIC_indicatorViewSize);
    indicatorView.tag = STATIC_indicatorViewTag;
    indicatorView.hidesWhenStopped = YES;
    [self addSubview:indicatorView];
    [indicatorView startAnimating];
}

- (void)lgjeropj_endButtonActivityIndicatorView
{
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[self viewWithTag:STATIC_indicatorViewTag];
    [indicatorView removeFromSuperview];
    self.enabled = YES;
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.4*(5/2)];
}


@end
