//
//  BEExtendedTabBarController.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEExtensibleViewController.h"
#import "BEExtensibleViewControllerDelegate.h"

#import "BEExtensionPresentationController.h"
#import "BEExtensionPercentDrivenInteractiveTransition.h"

#import "BETabBar.h"
#import "BETabBarDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface BEExtendedTabBarController : UIViewController<BETabBarDelegate, BEExtensionPercentDrivenInteractiveTransitionDelegate, BEExtensibleViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong, readonly) BETabBar *tabBar;
@property (nonatomic, strong, readonly) __kindof UIView *extendableView;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) __kindof UIViewController *selectedViewController;
@property (nonatomic, strong, readonly) NSArray<__kindof UIViewController *> *viewControllers;

- (__kindof UIView *)newExtendableView;
- (void)extendAnimated:(BOOL)animated;
- (BEExtensibleViewController *)extensibleViewController;
- (void)setExtendableViewHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers forAssosiatedItems:(NSArray<BETabBarItem *> *)items;

@end

NS_ASSUME_NONNULL_END
