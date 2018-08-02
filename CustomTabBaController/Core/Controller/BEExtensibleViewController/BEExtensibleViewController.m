//
//  BEExtensibleViewController.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEExtensibleViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface BEExtensibleViewController ()

@property (nonatomic, strong) BEBounceResolver *bounceResolver;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end


@implementation BEExtensibleViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePanGesture:)];
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
    self.panRecognizer = panRecognizer;
}

#pragma mark - Get/Set Methods

- (UIOffset)statusBarOffset {
    
    return UIOffsetMake(0.f, UIApplication.sharedApplication.statusBarFrame.size.height * 1.5f);
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

#pragma mark - Regular Methods

- (CGFloat)statusBarOffsetToContentHeightRatio:(CGFloat)ratio {
    
    return self.statusBarOffset.vertical / ratio;
}

- (void)transformAccordingTranslation:(CGFloat)translation withCurrentProgres:(CGFloat)progress {
    
    CGFloat threshold = [self.delegate dismissThresholdFor:self];
    if (translation >= 0.f) {
        [self.delegate extensibleViewController:self updateProgress:progress];
        CGFloat elastic = [self elasticTranslationFromTranslation:translation];
        self.view.transform = self.bounceResolver ? [self.bounceResolver normalizedTransformForTranslation:elastic] : CGAffineTransformTranslate(CGAffineTransformIdentity, 0.f, elastic);
        
        if (translation >= threshold) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (CGFloat)elasticTranslationFromTranslation:(CGFloat)currentTranslation {
    
    CGFloat factor = 0.5f;
    CGFloat threshold = 120.f;
    
    CGFloat elasticTranslation = 0.f;
    if (currentTranslation < threshold) {
        elasticTranslation = currentTranslation * factor;
    } else {
        CGFloat length = currentTranslation - threshold;
        CGFloat friction = 30.f * atanf(length / 120.f) + length / 3.f;
        elasticTranslation = friction + threshold * factor;
    }
    
    return elasticTranslation;
}

#pragma mark - Overrideable Animation Methods

- (void)animateShrink {}
- (void)animateExpand {}

#pragma mark - Pan Gesture Recognizer

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    BOOL shouldSkip = ![gestureRecognizer isEqual:self.panRecognizer] && !self.allowsDismissSwipe;
    if (!shouldSkip)  {
        
        if (self.isBeingDismissed) {
            [gestureRecognizer setEnabled:NO];
        } else {
            CGPoint translation = [gestureRecognizer translationInView:self.view];
            CGFloat progress = translation.y / [self percentage];
            switch (gestureRecognizer.state) {
                case UIGestureRecognizerStateBegan:
                    if (!self.bounceResolver && self.observableScrollView) {
                        self.bounceResolver = [[BEBounceResolver alloc] initWithRootView:self.view
                                                                    observableScrollView:self.observableScrollView];
                    }
                    break;
                case UIGestureRecognizerStateChanged:
                    if (self.allowsDismissSwipe) {
                        [self transformAccordingTranslation:translation.y withCurrentProgres:progress];
                    }
                    break;
                case UIGestureRecognizerStateEnded:
                    if (self.allowsDismissSwipe) {
                        if (progress > 0.2f) {
                            [self dismissViewControllerAnimated:YES completion:nil];
                        } else {
                            [UIView animateWithDuration:0.2
                                                  delay:0
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 [self.delegate extensibleViewController:self updateProgress:0];
                                                 self.view.transform = CGAffineTransformIdentity;
                                             } completion:nil];
                        }
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isEqual:self.panRecognizer];
}

@end

NS_ASSUME_NONNULL_END
