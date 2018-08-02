//
//  BEExtensionPresentationController.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEExtensibleViewController.h"

#import "BEExtensionPresentationController.h"


@interface BEExtensionPresentationController ()

@property (nonatomic, assign, getter=isPresented) BOOL presented;

@property (nonatomic, strong) UIView *dimmingView;

@property (nonatomic, strong) NSLayoutConstraint *presentedControllerHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *presentedControllerTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *snapshotConstraint;

@end

@implementation BEExtensionPresentationController

#pragma mark - Initialization

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController {
    
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        _presented = YES;
    }
    
    return self;
}

#pragma mark - Get/Set Methods

- (UIView *)dimmingView {
    
    if(!_dimmingView) {
        _dimmingView = [UIView new];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.alpha = 0.0f;
    }
    
    return _dimmingView;
}

#pragma mark - UIPresentationController

- (void)presentationTransitionWillBegin {
    
    UIWindow *window = self.containerView.window;
    if (window) {
        [self.containerView addSubview:self.dimmingView];
        self.dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[[self.dimmingView.leftAnchor constraintEqualToAnchor:window.leftAnchor],
                                                  [self.dimmingView.topAnchor constraintEqualToAnchor:window.topAnchor],
                                                  [self.dimmingView.rightAnchor constraintEqualToAnchor:window.rightAnchor],
                                                  [self.dimmingView.bottomAnchor constraintEqualToAnchor:window.bottomAnchor]]];
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.dimmingView.alpha = 0.5f;
        } completion:nil];
    }
}

- (void)dismissalTransitionWillBegin {
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = 0.0f;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        if (context.isCancelled) { return; }
        [self.dimmingView removeFromSuperview];
    }];
}

#pragma mark - <UIViewControllerAnimatedTransitioning>

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    BEExtensibleViewController *extensibleViewController = (BEExtensibleViewController *) self.presentedViewController;
    BEExtendedTabBarController *extendedTabBarController = (BEExtendedTabBarController *) self.presentingViewController;
    
    if (self.isPresented) {
        return [self animatePresentTransition:transitionContext
                   onExtendedTabBarController:extendedTabBarController
                   forExtensibleViewController:extensibleViewController];
    }
    
    [self animateDismissTransition:transitionContext
        onExtendedTabBarController:extendedTabBarController
        forExtensibleViewController:extensibleViewController];
}

#pragma mark - Regular Methods

- (void)animatePresentTransition:(id <UIViewControllerContextTransitioning>)transitionContext
    onExtendedTabBarController:(BEExtendedTabBarController *)extendedTabBarController
      forExtensibleViewController:(BEExtensibleViewController *)extensionViewController {
    
    self.presented = NO;
    [self.containerView addSubview:self.presentedView];
    self.presentedView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGFloat deltaY = self.containerView.bounds.size.height - extendedTabBarController.tabBar.bounds.size.height - extendedTabBarController.extendableView.bounds.size.height;
    self.presentedControllerTopConstraint = [self.presentedView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:deltaY];
    
    CGFloat height = UIScreen.mainScreen.bounds.size.height - extendedTabBarController.extendableView.frame.origin.y;
    self.presentedControllerHeightConstraint = [self.presentedView.heightAnchor constraintEqualToConstant:height];
    
    [NSLayoutConstraint activateConstraints:@[[self.presentedView.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor],
                                              [self.presentedView.rightAnchor constraintEqualToAnchor: self.containerView.rightAnchor],
                                              self.presentedControllerTopConstraint,
                                              self.presentedControllerHeightConstraint]];

    self.tabBarSnapshot = [extendedTabBarController.tabBar snapshotTabBarWithSeparator:YES];
    [self.containerView addSubview:self.tabBarSnapshot];
    
    self.tabBarSnapshot.translatesAutoresizingMaskIntoConstraints = NO;
    self.snapshotConstraint = [self.tabBarSnapshot.bottomAnchor constraintEqualToAnchor:extendedTabBarController.tabBar.bottomAnchor];
    [NSLayoutConstraint activateConstraints:@[[self.tabBarSnapshot.leftAnchor constraintEqualToAnchor:self.containerView.leftAnchor],
                                              [self.tabBarSnapshot.rightAnchor constraintEqualToAnchor:self.containerView.rightAnchor],
                                              [self.tabBarSnapshot.heightAnchor constraintEqualToAnchor:extendedTabBarController.tabBar.heightAnchor],
                                              self.snapshotConstraint]];
    [self.containerView layoutIfNeeded];
    self.presentedView.clipsToBounds = YES;
    
    CGFloat scale = 1.f - [extensionViewController statusBarOffsetToContentHeightRatio:extendedTabBarController.view.bounds.size.height];
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.8f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         extendedTabBarController.selectedViewController.view.clipsToBounds = YES;
                         extendedTabBarController.selectedViewController.view.transform = CGAffineTransformScale(extendedTabBarController.selectedViewController.view.transform, scale, scale);
                         extendedTabBarController.selectedViewController.view.layer.cornerRadius = 10.f;
                         self.snapshotConstraint.constant = self.tabBarSnapshot.bounds.size.height;
                         [extensionViewController animateExpand];
                         
                         self.presentedControllerHeightConstraint.constant = self.containerView.bounds.size.height - 50.f;
                         self.presentedControllerTopConstraint.constant = 50.f;
                         
                         [self.containerView layoutIfNeeded];
                         self.presentedView.layer.cornerRadius = 10.f;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

- (void)animateDismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext
   onExtendedTabBarController:(BEExtendedTabBarController *)extendedTabBarController
     forExtensibleViewController:(BEExtensibleViewController *)extensionViewController {
    
    self.presented = YES;
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.8f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [extendedTabBarController.extendableView setHidden:YES];
                         extendedTabBarController.selectedViewController.view.layer.cornerRadius = 0.f;
                         extendedTabBarController.selectedViewController.view.transform = CGAffineTransformIdentity;
                         extendedTabBarController.selectedViewController.view.frame = self.frameOfPresentedViewInContainerView;
                         
                         self.snapshotConstraint.constant = 0.f;
                         self.presentedControllerTopConstraint.constant = extendedTabBarController.extendableView.frame.origin.y - extensionViewController.view.transform.ty;
                         self.presentedControllerHeightConstraint.constant = UIScreen.mainScreen.bounds.size.height - extendedTabBarController.extendableView.frame.origin.y;
                         [extensionViewController animateShrink];
                         [self.containerView layoutIfNeeded];
                         self.presentedView.layer.cornerRadius = 0.f;
                     } completion:^(BOOL finished) {
                         
                         if (!transitionContext.transitionWasCancelled) {
                             [self.tabBarSnapshot removeFromSuperview];
                             self.tabBarSnapshot = nil;
                             [extendedTabBarController.extendableView setHidden:NO];
                         }
                         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
                     }];
}

@end
