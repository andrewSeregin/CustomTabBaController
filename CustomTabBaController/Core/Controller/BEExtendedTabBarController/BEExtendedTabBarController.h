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


@interface BEExtendedTabBarController : UIViewController<BETabBarDelegate, BEExtensionPercentDrivenInteractiveTransitionDelegate, BEExtensibleViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong, readonly) BETabBar *tabBar;
@property (nonatomic, strong, readonly) __kindof UIView *extendableView;

@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, assign) __kindof UIViewController *selectedViewController;

@property (nonatomic, strong) BEExtensionPresentationController *extensionPresentationController;
@property (nonatomic, strong) BEExtensionPercentDrivenInteractiveTransition *interactiveAnimator;

- (void)setItems:(NSArray<BETabBarItem *> *)items;

- (__kindof UIView *)newExtendableView;
- (void)extend;
- (BEExtensibleViewController *)extensibleViewController;;

@end
