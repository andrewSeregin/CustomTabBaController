//
//  BEExtensibleViewController.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEExtensibleViewController.h"

#import "UIView+ScrollViewDetection.h"


@interface BEExtensibleViewController ()

@property (nonatomic, strong) BEBounceResolver *bounceResolver;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end


@implementation BEExtensibleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self prepareGestureRecognizers];
}

- (UIOffset)statusBarOffset {
    
    return  UIOffsetMake(0, UIApplication.sharedApplication.statusBarFrame.size.height * 1.5);
}

- (CGFloat)ratioOfStatusBarOffsetToContentHeight:(CGFloat)contentHeight {
    
    return self.statusBarOffset.vertical / contentHeight;
}

- (void)prepareGestureRecognizers {
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePanRecognizer:)];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
    self.panRecognizer = panRecognizer;
    
}

- (void)transformAccordingTranslation:(CGFloat)translation andCurrentProgress:(CGFloat)progress {
    
    CGFloat threshold = [self.delegate dismissThresholdFor:self];
    if (translation < 0) { return; }
    [self.delegate extensibleViewController:self updateProgress:progress];
    
    CGFloat elastic = [self elasticTranslationFromTranslation:translation];
    self.view.transform = self.bounceResolver ? [self.bounceResolver normalizedTransformForTranslation:elastic] : CGAffineTransformTranslate(CGAffineTransformIdentity, 0, elastic);
    
    if (translation >= threshold) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (CGFloat)elasticTranslationFromTranslation:(CGFloat)currentTranslation {
    
    CGFloat factor = 1/2;
    CGFloat threshold = 120;
    
    if (currentTranslation < threshold) {
        return currentTranslation * factor;
    }
    
    CGFloat length = currentTranslation - threshold;
    CGFloat friction = 30 * atan(length / 120) + length / 3;
    return friction + threshold * factor;
}

- (BOOL)allowsDismissSwipe {
    
    return self.bounceResolver.isDismissEnabled;
}

- (CGFloat)percentage {
    
    BEExtendedTabBarController *extendedTabBarController = (BEExtendedTabBarController *)self.presentingViewController;
    return extendedTabBarController.extendableView.frame.origin.y;
}

- (nullable UIScrollView *)oservableScrollView {
    
    return nil;
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {

    if (![gestureRecognizer isEqual:self.panRecognizer] && ![self allowsDismissSwipe]) { return; }
    
    if (self.isBeingDismissed) {
        [gestureRecognizer setEnabled:NO];
        return;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    CGFloat progress = translation.y / [self percentage];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (!self.bounceResolver && self.oservableScrollView) {
                self.bounceResolver = [[BEBounceResolver alloc] initWithRootView:self.view
                                                         forObservableScrollView:self.oservableScrollView];
            }
            break;
        case UIGestureRecognizerStateChanged:
            if ([self allowsDismissSwipe]) {
                [self transformAccordingTranslation:translation.y andCurrentProgress:progress];
            }
            break;
        case UIGestureRecognizerStateEnded:
            if ([self allowsDismissSwipe]) {

                if (progress > 0.2) {
                    return [self dismissViewControllerAnimated:YES completion:nil];
                }
                
                [UIView animateWithDuration:0.2
                                      delay:0
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.delegate extensibleViewController:self updateProgress:0];
                                     self.view.transform = CGAffineTransformIdentity;
                                 } completion:nil];
                
            }
            break;
            
        default: break;
    }
}

- (void)animateShrink {}
- (void)animateExpand {}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isEqual:self.panRecognizer];
}

@end
