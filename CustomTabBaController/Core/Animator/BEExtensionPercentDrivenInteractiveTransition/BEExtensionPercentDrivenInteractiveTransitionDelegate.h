//
//  BEExtensionPercentDrivenInteractiveTransitionDelegate.h
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 19.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

@class BEExtensionPercentDrivenInteractiveTransition;


@protocol BEExtensionPercentDrivenInteractiveTransitionDelegate <NSObject>

- (void)percentDrivenInteractiveAnimatorWillStartTransition:(BEExtensionPercentDrivenInteractiveTransition *)animator;

@end
