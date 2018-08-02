//
//  BEExtensibleViewController.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEExtensibleViewController.h"


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
- (CGFloat)statusBarOffsetToContentHeightRatio:(CGFloat)ratio {
    
    return self.statusBarOffset.vertical / ratio;
}

- (void)prepareGestureRecognizers {
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePanGesture:)];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
    self.panRecognizer = panRecognizer;
    
}

- (void)transformAccordingTranslation:(CGFloat)translation withCurrentProgres:(CGFloat)progress {
    
    CGFloat threshold = [self.delegate dismissThresholdFor:self];
    if (translation >= 0) {
        [self.delegate extensibleViewController:self updateProgress:progress];
        CGFloat elastic = [self elasticTranslationFromTranslation:translation];
        self.view.transform = self.bounceResolver ? [self.bounceResolver normalizedTransformForTranslation:elastic] : CGAffineTransformTranslate(CGAffineTransformIdentity, 0, elastic);
        
        if (translation >= threshold) {
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
}

- (CGFloat)elasticTranslationFromTranslation:(CGFloat)currentTranslation {
    
    CGFloat factor = 0.5f;
    CGFloat threshold = 120.f;
    
    CGFloat elasticTranslation = 0;
    if (currentTranslation < threshold) {
        elasticTranslation = currentTranslation * factor;
    } else {
        CGFloat length = currentTranslation - threshold;
        CGFloat friction = 30.f * atanf(length / 120.f) + length / 3.f;
        elasticTranslation = friction + threshold * factor;
    }
    
    return elasticTranslation;
}

- (BOOL)allowsDismissSwipe {
    
    return self.bounceResolver.isDismissEnabled;
}

- (CGFloat)percentage {
    
    BEExtendedTabBarController *extendedTabBarController = nil;
    if ([self.presentingViewController isKindOfClass:[BEExtendedTabBarController class]]) {
        extendedTabBarController = (BEExtendedTabBarController *)self.presentingViewController;
    }
    
    return extendedTabBarController.extendableView.frame.origin.y;
}

- (nullable UIScrollView *)observableScrollView {
    
    return nil;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {

    if (![gestureRecognizer isEqual:self.panRecognizer] && ![self allowsDismissSwipe]) { return; }
    
    if (self.isBeingDismissed) {
        [gestureRecognizer setEnabled:NO];
        return;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    CGFloat progress = translation.y / [self percentage];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            if (!self.bounceResolver && self.observableScrollView) {
                self.bounceResolver = [[BEBounceResolver alloc] initWithRootView:self.view
                                                         forObservableScrollView:self.observableScrollView];
            }
            break;
        case UIGestureRecognizerStateChanged:
            if ([self allowsDismissSwipe]) {
                [self transformAccordingTranslation:translation.y withCurrentProgres:progress];
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
