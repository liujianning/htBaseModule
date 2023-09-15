//
//  LoadActivityIndicatorButton.h
//  LoadActivityIndicatorButton
//
//  Created by Apple on 22/7/21.
//  Copyright (c) 2022年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadActivityIndicatorButton;
@interface LoadActivityIndicatorButton : UIButton

@property (nonatomic, copy) void(^BLOCK_touchBlock)(LoadActivityIndicatorButton *);

@end
