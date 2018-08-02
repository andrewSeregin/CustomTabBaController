//
//  BEBounceResolver.h
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>


@interface BEBounceResolver : NSObject <UIScrollViewDelegate>

@property (nonatomic, assign, readonly, getter=isDismissedEnabled) BOOL isDismissEnabled;

- (nullable instancetype)initWithRootView:(UIView *)rootView forObservableScrollView:(nullable UIScrollView *)scrollView;

- (CGAffineTransform)currentTransform;
- (CGAffineTransform)normalizedTransformForTranslation:(CGFloat)translation;

@end
