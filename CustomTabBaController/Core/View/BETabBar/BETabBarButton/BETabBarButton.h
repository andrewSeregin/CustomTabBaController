//
//  BETabBarButton.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BETabBarItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface BETabBarButton : UIControl

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) UIImage *image;

@property (nonatomic, strong, nullable) UIColor *selectedTintColor;

- (instancetype)initFromTabBarItem:(BETabBarItem *)item;
- (void)orientationChanged:(UIDeviceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
