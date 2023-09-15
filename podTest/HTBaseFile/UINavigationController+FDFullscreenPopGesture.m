// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UINavigationController+FDFullscreenPopGesture.h"
#import <objc/runtime.h>

static char STATIC_distanceToLeftEdgeKey;
static char STATIC_prefersNavigationBarHiddenKey;
static char STATIC_interactivePopDisabledKey;
static char STATIC_navigationBarAppearanceEnabledKey;
static char STATIC_fullscreenPopGestureRecognizerKey;
static char STATIC_popGestureRecognizerDelegateKey;
static char STATIC_willAppearInjectBlockKey;

@interface var_FullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation var_FullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.fd_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint var_beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat var_maxAllowedInitialDistance = topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (var_maxAllowedInitialDistance > 0 && var_beginningLocation.x > var_maxAllowedInitialDistance) {
        return NO;
    }

    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:AsciiString(@"_isTransitioning")] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL var_isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = var_isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return YES;
}

@end

typedef void (^BLOCK_FDViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (FDFullscreenPopGesturePrivate)

@property (nonatomic, copy) BLOCK_FDViewControllerWillAppearInjectBlock var_willAppearInjectBlock;

@end

@implementation UIViewController (FDFullscreenPopGesturePrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method var_viewWillAppear_originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method var_viewWillAppear_swizzledMethod = class_getInstanceMethod(self, @selector(fd_viewWillAppear:));
        method_exchangeImplementations(var_viewWillAppear_originalMethod, var_viewWillAppear_swizzledMethod);
    
        Method var_viewWillDisappear_originalMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
        Method var_viewWillDisappear_swizzledMethod = class_getInstanceMethod(self, @selector(fd_viewWillDisappear:));
        method_exchangeImplementations(var_viewWillDisappear_originalMethod, var_viewWillDisappear_swizzledMethod);
    });
}

- (void)fd_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self fd_viewWillAppear:animated];
    
    if (self.var_willAppearInjectBlock) {
        self.var_willAppearInjectBlock(self, animated);
    }
}

- (void)fd_viewWillDisappear:(BOOL)animated
{
    // Forward to primary implementation.
    [self fd_viewWillDisappear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *viewController = self.navigationController.viewControllers.lastObject;
        if (viewController && !viewController.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

- (BLOCK_FDViewControllerWillAppearInjectBlock)var_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, &STATIC_willAppearInjectBlockKey);
}

- (void)setVar_willAppearInjectBlock:(BLOCK_FDViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, &STATIC_willAppearInjectBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UINavigationController (FDFullscreenPopGesture)

+ (void)load
{
    // Inject "-pushViewController:animated:"
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(fd_pushViewController:animated:);
        
        Method var_originalMethod = class_getInstanceMethod(class, originalSelector);
        Method var_swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(var_swizzledMethod), method_getTypeEncoding(var_swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(var_originalMethod), method_getTypeEncoding(var_originalMethod));
        } else {
            method_exchangeImplementations(var_originalMethod, var_swizzledMethod);
        }
    });
}

- (void)fd_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fd_fullscreenPopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *var_internalTargets = [self.interactivePopGestureRecognizer valueForKey:AsciiString(@"targets")];
        id var_internalTarget = [var_internalTargets.firstObject valueForKey:AsciiString(@"target")];
        SEL var_internalAction = NSSelectorFromString(AsciiString(@"handleNavigationTransition:"));
        self.fd_fullscreenPopGestureRecognizer.delegate = self.fd_popGestureRecognizerDelegate;
        [self.fd_fullscreenPopGestureRecognizer addTarget:var_internalTarget action:var_internalAction];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Handle perferred navigation bar appearance.
    [self fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    if (![self.viewControllers containsObject:viewController]) {
        [self fd_pushViewController:viewController animated:animated];
    }
}

- (void)fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.fd_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    BLOCK_FDViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) var_strongSelf = weakSelf;
        if (var_strongSelf) {
            [var_strongSelf setNavigationBarHidden:viewController.fd_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.var_willAppearInjectBlock = block;
    UIViewController *var_disappearingViewController = self.viewControllers.lastObject;
    if (var_disappearingViewController && !var_disappearingViewController.var_willAppearInjectBlock) {
        var_disappearingViewController.var_willAppearInjectBlock = block;
    }
}

- (var_FullscreenPopGestureRecognizerDelegate *)fd_popGestureRecognizerDelegate
{
    var_FullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, &STATIC_popGestureRecognizerDelegateKey);
    
    if (!delegate) {
        delegate = [[var_FullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, &STATIC_popGestureRecognizerDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)fd_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, &STATIC_fullscreenPopGestureRecognizerKey);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, &STATIC_fullscreenPopGestureRecognizerKey, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (BOOL)fd_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, &STATIC_navigationBarAppearanceEnabledKey);
    if (number) {
        return number.boolValue;
    }
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setFd_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    objc_setAssociatedObject(self, &STATIC_navigationBarAppearanceEnabledKey, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (FDFullscreenPopGesture)

- (BOOL)fd_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, &STATIC_interactivePopDisabledKey) boolValue];
}

- (void)setFd_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, &STATIC_interactivePopDisabledKey, @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fd_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, &STATIC_prefersNavigationBarHiddenKey) boolValue];
}

- (void)setFd_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, &STATIC_prefersNavigationBarHiddenKey, @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)fd_interactivePopMaxAllowedInitialDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, &STATIC_distanceToLeftEdgeKey) doubleValue];
#else
    return [objc_getAssociatedObject(self, &STATIC_distanceToLeftEdgeKey) floatValue];
#endif
}

- (void)setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    objc_setAssociatedObject(self, &STATIC_distanceToLeftEdgeKey, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
