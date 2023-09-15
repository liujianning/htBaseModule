//
//  LoadActivityIndicatorButton.m
//  LoadActivityIndicatorButton
//
//  Created by Apple on 22/7/21.
//  Copyright (c) 2022年 Apple. All rights reserved.
//

#import "LoadActivityIndicatorButton.h"

@implementation LoadActivityIndicatorButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickAction
{
    if (self.BLOCK_touchBlock) {
        self.BLOCK_touchBlock(self);
    }
}

@end
