//
//  BETabBarItem.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 27.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BETabBarItem.h"

NS_ASSUME_NONNULL_BEGIN

@implementation BETabBarItem

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image {
    
    self = [self init];
    
    if (self) {
        _image = image;
        _title = title;
    }
    
    return self;
}

@end

NS_ASSUME_NONNULL_END
