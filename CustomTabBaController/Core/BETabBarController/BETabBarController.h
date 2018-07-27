//
//  BETabBarController.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BETabBar.h"
#import "BETabBarDelegate.h"


@interface BETabBarController : UIViewController<BETabBarDelegate>

@property (nonatomic, strong, readonly) BETabBar *tabBar;
@property (nonatomic, strong, readonly) __kindof UIView *extendableView;

@property (nonatomic, strong) NSArray<__kindof UIViewController *> *viewControllers;

@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, assign) __kindof UIViewController *selectedViewController;

- (__kindof UIView *)newExtendableView;
- (void)setItems:(NSArray<BETabBarItem *> *)items;

@end
