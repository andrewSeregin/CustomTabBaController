//
//  BETransformNormalizer.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 01.08.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BEBounceResolver.h"

@interface BETransformNormalizer : NSObject

@property (nonatomic, assign) BOOL needNormalization;
@property (nonatomic, weak) BEBounceResolver *bounceResolver;

- (instancetype)initWithBounceResolver:(BEBounceResolver *)bounceResolver;
- (CGAffineTransform)normalizedTransformForTranslation:(CGFloat)translation;

@end
