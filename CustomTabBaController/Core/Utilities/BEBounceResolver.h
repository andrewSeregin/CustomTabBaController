//
//  BEBounceResolver.h
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import "UIView+ScrollViewDetection.h"


@interface BEBounceResolver : NSObject <UIScrollViewDelegate>

@property (nonatomic, assign, readonly) BOOL isDismissEnabled;

- (instancetype)initForRootView:(UIView *)rootView;

- (CGAffineTransform)currentTransform;
- (CGAffineTransform)normalizedTransformForTranslation:(CGFloat)translation;

@end
