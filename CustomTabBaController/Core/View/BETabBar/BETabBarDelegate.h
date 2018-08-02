//
//  BETabBarDelegate.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 26.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BETabBar, BETabBarItem;


@protocol BETabBarDelegate <NSObject>

- (void)tabBar:(BETabBar *)tabBar didSelectItem:(BETabBarItem *)item;

@end
