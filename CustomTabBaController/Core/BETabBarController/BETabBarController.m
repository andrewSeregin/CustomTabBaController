//
//  BETabBarController.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BETabBarController.h"
#import "BETabBarButton.h"
#import "BELayoutContainerView.h"
#import "BEConstants.h"

@interface BETabBarController ()

@property (nonatomic, strong) NSLayoutConstraint *tabBarHeightConstraint;
@property (nonatomic, strong) BELayoutContainerView *layoutContainerView;

@end

@implementation BETabBarController

@synthesize tabBar = _tabBar;
@synthesize extendableView = _extendableView;

- (__kindof UIView*)extendableView {
    
    if(!_extendableView) {
        _extendableView = [self newExtendableView];
        if (!_extendableView) {
            _extendableView = [UIView new];
            _extendableView.backgroundColor = UIColor.whiteColor;
        }
    }
    
    return _extendableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupLayoutContainerView];
    [self setupTabBar];
    
    [self.tabBar setItems:@[[[BETabBarButton alloc] initWithImage:[UIImage imageNamed:@"window"]
                                                            title:@"window"],
                            [[BETabBarButton alloc] initWithImage:[UIImage imageNamed:@"paper_piece"]
                                                            title:@"paper_piece"]]];
    
    UIViewController *controllerOne = [UIViewController new];
    controllerOne.view.backgroundColor = UIColor.greenColor;
    
    UIViewController *controllerTwo = [UIViewController new];
    controllerTwo.view.backgroundColor = UIColor.brownColor;
    
    self.viewControllers = @[controllerOne, controllerTwo];
    
}

- (void)setupLayoutContainerView {
    
    if (!self.layoutContainerView) {
        self.layoutContainerView = [BELayoutContainerView new];
        [self.view addSubview:self.layoutContainerView];
        self.layoutContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[[self.layoutContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                                  [self.layoutContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                                  [self.layoutContainerView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                                  [self.layoutContainerView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor]]];
    }
}

- (void)setupTabBar {
    
    if (!_tabBar) {
        _tabBar = [[BETabBar alloc] init];
        _tabBar.delegate = self;
        [self.view addSubview:_tabBar];
        _tabBar.translatesAutoresizingMaskIntoConstraints = NO;
        self.tabBarHeightConstraint = [_tabBar.heightAnchor constraintEqualToConstant:BETabBarHeightVertical];
        [NSLayoutConstraint activateConstraints:@[[_tabBar.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                                  [_tabBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                                  [_tabBar.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                                  self.tabBarHeightConstraint]];
    }
}

- (void)prepareExtendableView {
    
    [self.view insertSubview:self.extendableView belowSubview:self.tabBar];
    self.extendableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[self.extendableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                              [self.extendableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                              [self.extendableView.bottomAnchor constraintEqualToAnchor:self.tabBar.topAnchor],
                                              [self.extendableView.heightAnchor constraintEqualToConstant:71]]];
}

- (void)viewSafeAreaInsetsDidChange {
    
    [super viewSafeAreaInsetsDidChange];
    CGFloat tabBarHeight = self.view.bounds.size.width > self.view.bounds.size.height ? BETabBarHeightHorizontal : BETabBarHeightVertical;
    self.tabBarHeightConstraint.constant = self.view.safeAreaInsets.bottom + tabBarHeight;
    
    [self updateSelectedViewControllerSafeAreaInsets];
}

- (void)updateSelectedViewControllerSafeAreaInsets {
    self.selectedViewController.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, self.tabBarHeightConstraint.constant, 0);
}

- (void)tabBar:(BETabBar *)tabBar requestReloadingViewForSelectedItem:(BETabBarButton *)item {
    
    [self.selectedViewController willMoveToParentViewController:nil];
    [self.selectedViewController.view removeFromSuperview];
    [self.selectedViewController removeFromParentViewController];
    
    NSUInteger index = [self.tabBar.items indexOfObject:item];
    UIViewController *controller = self.viewControllers[index];
    [self addChildViewController:controller];
    [self.layoutContainerView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    self.selectedViewController = controller;
    
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[controller.view.topAnchor constraintEqualToAnchor:self.layoutContainerView.topAnchor],
                                              [controller.view.bottomAnchor constraintEqualToAnchor:self.layoutContainerView.bottomAnchor],
                                              [controller.view.leftAnchor constraintEqualToAnchor:self.layoutContainerView.leftAnchor],
                                              [controller.view.rightAnchor constraintEqualToAnchor:self.layoutContainerView.rightAnchor]]];
    
    
}

- (__kindof UIView *)newExtendableView {
    
    return nil;
}

@end
