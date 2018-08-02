//
//  BETabBarButton.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BETabBarItem.h"


@interface BETabBarButton : UIControl


@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nonnull) UIImage *image;

@property (nonatomic, strong, nullable) UIColor *selectedTintColor;

NS_ASSUME_NONNULL_BEGIN

- (instancetype)initFromTabBarItem:(BETabBarItem *)item;

NS_ASSUME_NONNULL_END

- (void)orientationChanged:(UIDeviceOrientation)orientation;

@end
