//
//  BETabBarController.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEExtendedTabBarController.h"

#import "BEExtendedTabBarControlleConstants.h"
#import "BEExtendedTabBarControllerContainerView.h"
#import "BETabBarButton.h"


NS_ASSUME_NONNULL_BEGIN

@interface BEExtendedTabBarController  ()

@property (nonatomic, strong) NSLayoutConstraint *extendableViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *tabBarHeightConstraint;

@property (nonatomic, strong) NSArray<__kindof UIViewController *> *viewControllers;

@property (nonatomic, strong) BEExtendedTabBarControllerContainerView *containerView;
@property (nonatomic, strong) BEExtensionPresentationController *extensionPresentationController;
@property (nonatomic, strong) BEExtensionPercentDrivenInteractiveTransition *interactiveAnimator;

@end


@implementation BEExtendedTabBarController 

@synthesize tabBar = _tabBar;
@synthesize extendableView = _extendableView;

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpContainerView];
    [self setUpTabBar];
    [self setUpExtendableView];
    
    [self.extendableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleTapGesture:)]];
    self.interactiveAnimator = [[BEExtensionPercentDrivenInteractiveTransition alloc] initWithSourceView: self.extendableView];
    self.interactiveAnimator.delegate = self;
}

- (void)viewSafeAreaInsetsDidChange {
    
    [super viewSafeAreaInsetsDidChange];
    
    CGFloat tabBarHeight = self.view.bounds.size.width > self.view.bounds.size.height ? BETabBarHeightHorizontal : BETabBarHeightVertical;
    self.tabBarHeightConstraint.constant = self.view.safeAreaInsets.bottom + tabBarHeight;
    self.selectedViewController.additionalSafeAreaInsets = UIEdgeInsetsMake(0.f, 0.f, self.tabBarHeightConstraint.constant, 0.f);
}

#pragma mark - Set Up

- (void)setUpContainerView {
    
    [self.view addSubview:self.containerView];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                              [self.containerView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                              [self.containerView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor]]];
}

- (void)setUpTabBar {
    
    [self.view addSubview:self.tabBar];
    self.tabBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.tabBarHeightConstraint = [self.tabBar.heightAnchor constraintEqualToConstant:BETabBarHeightVertical];
    [NSLayoutConstraint activateConstraints:@[[self.tabBar.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                              [self.tabBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                              [self.tabBar.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
                                              self.tabBarHeightConstraint]];
}

- (void)setUpExtendableView {
    
    [self.view insertSubview:self.extendableView belowSubview:self.tabBar];
    self.extendableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.extendableViewBottomConstraint = [self.extendableView.bottomAnchor constraintEqualToAnchor:self.tabBar.topAnchor];
    [NSLayoutConstraint activateConstraints:@[[self.extendableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                              [self.extendableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                              self.extendableViewBottomConstraint,
                                              [self.extendableView.heightAnchor constraintEqualToConstant:71.f]]];
}

#pragma mark - <BETabBarDelegate>

- (void)tabBar:(BETabBar *)tabBar didSelectItem:(BETabBarItem *)item {
    
    [self.selectedViewController willMoveToParentViewController:nil];
    [self.selectedViewController.view removeFromSuperview];
    [self.selectedViewController removeFromParentViewController];
    
    NSUInteger index = [self.tabBar.items indexOfObject:item];
    UIViewController *controller = self.viewControllers[index];
    
    [self addChildViewController:controller];
    [self.containerView addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    self.selectedViewController = controller;
    
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[controller.view.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
                                              [controller.view.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor],
                                              [controller.view.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor],
                                              [controller.view.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor]]];
}

#pragma mark - <BEExtensionPercentDrivenInteractiveTransitionDelegate>

- (void)percentDrivenInteractiveAnimatorWillStartTransition:(BEExtensionPercentDrivenInteractiveTransition *)animator {
    
    [self extendAnimated:YES];
}

#pragma mark - <BEExtensibleViewControllerDelegate>

- (CGFloat)dismissThresholdFor:(BEExtensibleViewController *)extensibleViewController {
    
    return self.extendableView.frame.origin.y;
}

- (void)extensibleViewController:(BEExtensibleViewController *)extensibleViewController updateProgress:(CGFloat)currentProgress {
    
    CGFloat ratio = [extensibleViewController statusBarOffsetToContentHeightRatio:self.view.bounds.size.height];
    CGFloat infinitesimal = ratio * currentProgress;
    CGFloat scale = 1.f - ratio + infinitesimal;
    
    self.selectedViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}

#pragma mark - <UIViewControllerTransitioningDelegate>

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    return  self.extensionPresentationController;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return self.extensionPresentationController;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(nullable UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    
    self.extensionPresentationController = [[BEExtensionPresentationController alloc] initWithPresentedViewController:presented
                                                                                             presentingViewController:presenting];
    
    return self.extensionPresentationController;
}

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    return self.interactiveAnimator;
}

#pragma mark - Get/Set Methods

- (BEExtendedTabBarControllerContainerView *)containerView {
    
    if (!_containerView) {
        _containerView = [BEExtendedTabBarControllerContainerView new];
    }
    
    return _containerView;
}

- (__kindof UIView*)extendableView {
    
    if(!_extendableView) {
        _extendableView = [self newExtendableView];
    }
    
    return _extendableView;
}

- (BETabBar *)tabBar {
    
    if (!_tabBar) {
        _tabBar = [BETabBar new];
        _tabBar.delegate = self;
    }
    
    return _tabBar;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex < self.tabBar.items.count) {
        _selectedIndex = selectedIndex;
        self.tabBar.selectedItem = self.tabBar.items[selectedIndex];
    }
}

#pragma mark - Regular Methods

- (__kindof UIView *)newExtendableView {
    
    UIView *newExtendableView = [UIView new];
    newExtendableView.backgroundColor = UIColor.whiteColor;
    
    return newExtendableView;
}

- (BEExtensibleViewController *)extensibleViewController {
    
    return  [BEExtensibleViewController new];
}

-(BEExtensibleViewController *)preparedExtensibleViewController {
    
    BEExtensibleViewController *controller = [self extensibleViewController];
    controller.transitioningDelegate = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.modalPresentationCapturesStatusBarAppearance = YES;
    controller.delegate = self;
    
    return controller;
}

- (void)extendAnimated:(BOOL)animated {
    
    [self presentViewController:[self preparedExtensibleViewController]
                       animated:animated
                     completion:nil];
}

- (void)setExtendableViewHidden:(BOOL)hidden animated:(BOOL)animated {
    
    CGFloat alpha = 0.f;
    CGFloat constant = self.tabBarHeightConstraint.constant;
    if (!hidden) {
        alpha = 1.f;
        constant = 0.f;
    }
    self.extendableViewBottomConstraint.constant = constant;
    if (animated) {
        [self.extendableView setHidden:NO];
        [UIView animateWithDuration:0.7 animations:^{
            self.extendableView.alpha = alpha;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.extendableView setHidden:hidden];
        }];
    } else {
        self.extendableView.alpha = alpha;
        [self.extendableView setHidden:hidden];
    }
}

- (void)configureWithViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers tabBarItems:(NSArray<BETabBarItem *> *)items {
    
    if (viewControllers.count == items.count) {
        self.viewControllers = viewControllers;
        self.tabBar.items = items;
    }
}

#pragma mark - Tap Gesture Recognizer

- (void)handleTapGesture:(UITapGestureRecognizer *)tapRecognizer  {
    
    if (tapRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self extendAnimated:YES];
    }
}

@end

NS_ASSUME_NONNULL_END
