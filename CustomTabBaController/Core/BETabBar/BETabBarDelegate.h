//
//  BETabBarDelegate.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 26.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BETabBar, BETabBarButton;

@protocol BETabBarDelegate <NSObject>

- (void)tabBar:(BETabBar *)tabBar requestReloadingViewForSelectedItem:(BETabBarButton *)item;

@end
