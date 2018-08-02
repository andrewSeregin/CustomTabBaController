//
//  BEBounceResolver.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEBounceResolver.h"
#import "BETransformNormalizer.h"


NS_ASSUME_NONNULL_BEGIN

@interface BEBounceResolver ()

@property (nonatomic, weak) UIView *rootView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) BETransformNormalizer *transformNormalizer;

@end

NS_ASSUME_NONNULL_END

@implementation BEBounceResolver

#pragma mark - Initialization

- (nullable instancetype)initWithRootView:(UIView *)rootView
                     observableScrollView:(nullable UIScrollView *)scrollView {
    
    
    if (!scrollView) {
        self = nil;
    } else  {
        self = [super init];
        
        if (self) {
            _rootView = rootView;
            scrollView.delegate = self;
            _scrollView = scrollView;
            _transformNormalizer = [[BETransformNormalizer alloc] initWithBounceResolver:self];
        }
    }
    
    return self;
}


#pragma mark - Regular Methods

- (CGFloat)scrollOffset {
    
    CGFloat scrollOffset = 0;
    if (self.scrollView) {
        scrollOffset = self.scrollView.contentOffset.y + self.scrollView.contentInset.top;
        if (@available(iOS 11.0, *)) {
            scrollOffset += self.scrollView.safeAreaInsets.top;
        }
    }
    
    return scrollOffset;
}

- (CGAffineTransform)currentTransform {
    return self.rootView ? self.rootView.transform : CGAffineTransformIdentity;
}

- (CGAffineTransform)normalizedTransformForTranslation:(CGFloat)translation {
    return [self.transformNormalizer normalizedTransformForTranslation:translation];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollViewDidScroll];
}

- (void)scrollViewDidScroll {
    
    BOOL needСontinue = YES;
    if (self.scrollView) {
        if (self.scrollOffset > 0) {
            self.scrollView.bounces = YES;
            _isDismissEnabled = NO;
            needСontinue = NO;
        } else if (needСontinue) {
            BOOL isDecelerating = self.scrollView ? self.scrollView.isDecelerating : NO;
            if (isDecelerating) {
                self.rootView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.scrollOffset);
                for (UIView *subview in self.scrollView.subviews) {
                    subview.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.scrollOffset);
                }
                needСontinue = NO;
            } else if (needСontinue) {
                if (self.scrollView.isTracking) {
                    self.transformNormalizer.needNormalization = YES;
                    for (UIView *subview in self.scrollView.subviews) {
                        subview.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.scrollOffset);
                    }
                    self.scrollView.bounces = NO;
                    _isDismissEnabled = YES;
                }
            }
        }
    }
}

@end

