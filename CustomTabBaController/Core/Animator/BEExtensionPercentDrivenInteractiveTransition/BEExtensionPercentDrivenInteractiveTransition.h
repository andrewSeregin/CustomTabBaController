//
//  ExtensionPercentDrivenInteractiveTransition.h
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEExtensionPercentDrivenInteractiveTransitionDelegate.h"


@interface BEExtensionPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, weak) id<BEExtensionPercentDrivenInteractiveTransitionDelegate> delegate;

- (instancetype)initWithSourceView:(UIView *)sourceView;

@end
