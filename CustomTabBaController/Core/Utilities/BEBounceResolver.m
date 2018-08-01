//
//  BEBounceResolver.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEBounceResolver.h"


@interface BETransformNormalizer : NSObject

@property (nonatomic, assign) BOOL needNormalization;
@property (nonatomic, strong) BEBounceResolver *bounceResolver;

- (instancetype)initWithBounceResolver:(BEBounceResolver *)bounceResolver;
- (CGAffineTransform)normalizedTransformForTranslation:(CGFloat)translation;

@end

@interface BETransformNormalizer ()

@property (nonatomic, strong) NSNumber *deltaY;

@end


@implementation BETransformNormalizer

- (instancetype)initWithBounceResolver:(BEBounceResolver *)bounceResolver {
    
    self = [super init];
    if (self) {
        _bounceResolver = bounceResolver;
    }
    
    return self;
}

- (CGAffineTransform)normalizedTransformForTranslation:(CGFloat)translation {
    
    CGFloat originalTransform = self.bounceResolver.currentTransform.ty;
    if (self.deltaY) {
        originalTransform -= self.deltaY.floatValue;
    }
    CGFloat translationY = self.needNormalization ? originalTransform + translation : translation;
    self.deltaY = [NSNumber numberWithFloat:translation];
    
    return CGAffineTransformTranslate(CGAffineTransformIdentity, 0, translationY);
}

@end


@interface BEBounceResolver ()

@property (nonatomic, weak) UIView *rootView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) BETransformNormalizer *transformNormalizer;

@end


@implementation BEBounceResolver

- (instancetype)initForRootView:(UIView *)rootView {
    
    self = [super init];
    if (self) {
        UIScrollView *scrollView = rootView.detectedScrollView;
        if (!scrollView) { return nil; }
        _rootView = rootView;
        _scrollView = scrollView;
        scrollView.delegate = self;
        _transformNormalizer = [[BETransformNormalizer alloc] initWithBounceResolver:self];
    }
    
    return self;
}

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
    return  [self.transformNormalizer normalizedTransformForTranslation:translation];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollViewDidScroll];
}

- (void)scrollViewDidScroll {
    
    BOOL isDecelerating = self.scrollView ? self.scrollView.isDecelerating : NO;
    
    if (self.scrollOffset > 0) {
        self.scrollView.bounces = YES;
        _isDismissEnabled = NO;
        return;
    }
    
    if (isDecelerating) {
        self.rootView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -self.scrollOffset);
        for (UIView *subview in self.scrollView.subviews) {
            subview.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.scrollOffset);
        }
        return;
    }
    
    if (self.scrollView.isTracking) {
        self.transformNormalizer.needNormalization = YES;
        for (UIView *subview in self.scrollView.subviews) {
            subview.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, self.scrollOffset);
        }
        self.scrollView.bounces = NO;
        _isDismissEnabled = YES;
    }
}

@end

