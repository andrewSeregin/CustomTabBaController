//
//  UIView+ScrollViewDetection.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "UIView+ScrollViewDetection.h"

@implementation UIView (ScrollViewDetection)

- (UIScrollView *)detectedScrollView {

    UIScrollView *detectedScrollView = nil;
    for (UIView *subview in self.subviews) {
        UIScrollView *currentSubview = (UIScrollView *)subview;
        if (currentSubview) {
            detectedScrollView = currentSubview;
            break;
        }
    }
    
    return detectedScrollView;
}

@end
