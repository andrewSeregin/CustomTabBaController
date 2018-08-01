//
//  BETabBarController.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEExtendedTabBarController.h"

#import "BEExtendedTabBarControlleConstants.h"
#import "BELayoutContainerView.h"
#import "BETabBarButton.h"


@interface BEExtendedTabBarController  ()

@property (nonatomic, strong) NSLayoutConstraint *extendableViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *tabBarHeightConstraint;

@property (nonatomic, strong) BELayoutContainerView *layoutContainerView;


@end

@implementation BEExtendedTabBarController 

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
    [self prepareExtendableView];
    
    [self.extendableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleTapRecogniser)]];
    self.interactiveAnimator = [[BEExtensionPercentDrivenInteractiveTransition alloc] initWithSourceView: self.extendableView];
    self.interactiveAnimator.delegate = self;
    
    
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
    self.extendableViewBottomConstraint = [self.extendableView.bottomAnchor constraintEqualToAnchor:self.tabBar.topAnchor];
    [NSLayoutConstraint activateConstraints:@[[self.extendableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                              [self.extendableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
                                              self.extendableViewBottomConstraint,
                                              [self.extendableView.heightAnchor constraintEqualToConstant:71]]];
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


- (void)viewSafeAreaInsetsDidChange {
    
    [super viewSafeAreaInsetsDidChange];
    CGFloat tabBarHeight = self.view.bounds.size.width > self.view.bounds.size.height ? BETabBarHeightHorizontal : BETabBarHeightVertical;
    self.tabBarHeightConstraint.constant = self.view.safeAreaInsets.bottom + tabBarHeight;
    
    [self updateSelectedViewControllerSafeAreaInsets];
}

- (void)updateSelectedViewControllerSafeAreaInsets {
    self.selectedViewController.additionalSafeAreaInsets = UIEdgeInsetsMake(0, 0, self.tabBarHeightConstraint.constant, 0);
}

- (void)tabBar:(BETabBar *)tabBar didSelectItem:(BETabBarItem *)item {
    
    [self.selectedViewController willMoveToParentViewController:nil];
    [self.selectedViewController.view removeFromSuperview];
    [self.selectedViewController removeFromParentViewController];
    
    NSUInteger index = [self.tabBar.items indexOfObject:item];
    UIViewController *controller = self.tabBar.items[index].associatedController;
    
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

- (void)setItems:(NSArray<BETabBarItem *> *)items {
    self.tabBar.items = items;
    self.selectedIndex = 0;
    
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex < self.tabBar.items.count) {
        _selectedIndex = selectedIndex;
        self.tabBar.selectedItem = self.tabBar.items[selectedIndex];
    }
}

- (__kindof UIView *)newExtendableView {
    
    return nil;
}

- (void)handleTapRecogniser {
    
    [self extend];
}

- (void)percentDrivenInteractiveAnimatorWillStartTransition:(BEExtensionPercentDrivenInteractiveTransition *)animator {
    
    [self extend];
}

- (void)extend {
    
    [self presentViewController:[self preparedExtensibleViewController]
                       animated:YES
                     completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    return  self.extensionPresentationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return self.extensionPresentationController;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source {
    
    
    self.extensionPresentationController = [[BEExtensionPresentationController alloc] initWithPresentedViewController:presented
                                                                                             presentingViewController:presenting];
    
    return self.extensionPresentationController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    return self.interactiveAnimator;
}

- (CGFloat)dismissThresholdFor:(BEExtensibleViewController *)extensibleViewController {
    
    return self.extendableView.frame.origin.y;
}

- (void)extensibleViewController:(BEExtensibleViewController *)extensibleViewController updateProgress:(CGFloat)currentProgress {
    
    CGFloat ratio = [extensibleViewController ratioOfStatusBarOffsetToContentHeight:self.view.bounds.size.height];
    CGFloat infinitesimal = ratio * currentProgress;
    CGFloat scale = 1 - ratio + infinitesimal;
    
    self.selectedViewController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
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

@end
