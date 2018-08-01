//
//  BEExtensibleViewControllerDelegate.h
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

@class BEExtensibleViewController;


@protocol BEExtensibleViewControllerDelegate <NSObject>

@required
- (CGFloat)dismissThresholdFor:(BEExtensibleViewController *)extensibleViewController;
- (void)extensibleViewController:(BEExtensibleViewController *)extensibleViewController updateProgress:(CGFloat)currentProgress;

@end
