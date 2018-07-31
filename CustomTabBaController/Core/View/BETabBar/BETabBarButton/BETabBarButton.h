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

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIColor *selectionTintColor;

- (instancetype)initFromTabBarItem:(BETabBarItem *)item;

- (void)orientationChanged:(UIDeviceOrientation)orientation;

@end
