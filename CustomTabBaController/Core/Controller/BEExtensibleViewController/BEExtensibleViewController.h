//
//  BEExtensibleViewController.h
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEBounceResolver.h"
#import "BEExtendedTabBarController.h"
#import "BEExtensibleViewControllerDelegate.h"


@interface BEExtensibleViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, assign, readonly) UIOffset statusBarOffset;
@property (nonatomic, weak) id<BEExtensibleViewControllerDelegate> delegate;

- (CGFloat)ratioOfStatusBarOffsetToContentHeight:(CGFloat)denominator;
- (nullable UIScrollView *)oservableScrollView;
- (void)animateShrink;
- (void)animateExpand;

@end



