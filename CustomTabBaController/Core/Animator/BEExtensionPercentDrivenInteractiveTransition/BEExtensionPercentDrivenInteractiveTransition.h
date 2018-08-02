//
//  ExtensionPercentDrivenInteractiveTransition.h
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEExtensionPercentDrivenInteractiveTransitionDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface BEExtensionPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, weak) id<BEExtensionPercentDrivenInteractiveTransitionDelegate> delegate;

- (instancetype)initWithSourceView:(UIView *)sourceView;

@end

NS_ASSUME_NONNULL_END
