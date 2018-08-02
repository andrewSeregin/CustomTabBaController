//
//  AppleMusicPercentDrivenInteractiveTransition.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEExtensionPercentDrivenInteractiveTransition.h"


NS_ASSUME_NONNULL_BEGIN

@interface BEExtensionPercentDrivenInteractiveTransition ()

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) BOOL needsToComplete;

@end

NS_ASSUME_NONNULL_END


@implementation BEExtensionPercentDrivenInteractiveTransition

#pragma mark - Initialization

- (instancetype)initWithSourceView:(UIView *)sourceView {
    
    self = [super init];
    
    if (self) {
        _sourceView = sourceView;
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(handlePanGesture:)];
        [self.sourceView addGestureRecognizer:self.panGesture];
    }
    
    return self;
}

#pragma mark - Pan Gesture Recognizer

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
