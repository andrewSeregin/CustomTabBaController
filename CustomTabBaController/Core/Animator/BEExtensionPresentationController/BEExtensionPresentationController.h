//
//  BEExtensionPresentationController.h
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEExtendedTabBarController.h"


NS_ASSUME_NONNULL_BEGIN

@interface BEExtensionPresentationController : UIPresentationController <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong, nullable) UIView *tabBarSnapshot;

@end

NS_ASSUME_NONNULL_END
