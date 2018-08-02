//
//  BETransformNormalizer.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 01.08.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BETransformNormalizer.h"


NS_ASSUME_NONNULL_BEGIN

@interface BETransformNormalizer ()

@property (nonatomic, nullable, strong) NSNumber *deltaY;

@end


@implementation BETransformNormalizer


#pragma mark - Initialization

- (instancetype)initWithBounceResolver:(BEBounceResolver *)bounceResolver {
    
    self = [super init];
    
    if (self) {
        _bounceResolver = bounceResolver;
    }
    
    return self;
}

#pragma mark - Regular Methods

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

NS_ASSUME_NONNULL_END
