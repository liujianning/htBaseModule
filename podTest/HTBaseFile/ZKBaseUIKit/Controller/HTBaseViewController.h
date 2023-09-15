//
//  HTBaseViewController.h
// 
//
//  Created by Apple on 2022/9/13.
//  Copyright © 2021 huzhongkai. All rights reserved.
//

#import "ZKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTBaseViewController : ZKBaseViewController

@property (nonatomic, assign) BOOL whiteBackButton;
@property (nonatomic, strong) UIActivityIndicatorView *backIndicatorView;

- (void)lgjeropj_backAction;

@end

NS_ASSUME_NONNULL_END
