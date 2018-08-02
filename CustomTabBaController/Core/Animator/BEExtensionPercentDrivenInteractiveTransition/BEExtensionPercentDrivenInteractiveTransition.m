//
//  AppleMusicPercentDrivenInteractiveTransition.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEExtensionPercentDrivenInteractiveTransition.h"


@interface BEExtensionPercentDrivenInteractiveTransition ()

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) BOOL needsToComplete;

@end

@implementation BEExtensionPercentDrivenInteractiveTransition

- (instancetype)initWithSourceView:(UIView *)sourceView {
    
    self = [super init];
    if (self) {
        _sourceView = sourceView;
        [self prepareGestureRecognizer];
    }
    
    return self;
}

- (void)prepareGestureRecognizer {
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePanGesture:)];
    [self.sourceView addGestureRecognizer:panRecognizer];
    self.panGesture = panRecognizer;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panRecognizer {
    
    CGPoint transition = [panRecognizer translationInView:self.sourceView];
    CGFloat delta = self.sourceView.frame.origin.y - UIApplication.sharedApplication.statusBarFrame.size.height;
    
    CGFloat progress = -transition.y / delta;
    self.completionSpeed = 0.5f;
    
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self.delegate percentDrivenInteractiveAnimatorWillStartTransition:self];
            break;
        case UIGestureRecognizerStateChanged:
            self.needsToComplete = progress > 0.05f;
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
            [self cancelInteractiveTransition];
            break;
        case UIGestureRecognizerStateEnded:
            if (self.needsToComplete) {
                self.completionSpeed = 1.0f;
                [self finishInteractiveTransition];
                return;
            }
            self.completionSpeed = 0.2f;
            [self cancelInteractiveTransition];
            break;
        default:
            break;
    }
}

@end
