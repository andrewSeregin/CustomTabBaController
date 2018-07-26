//
//  BETabBarButtonDelegate.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 26.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BETabBarButton;

@protocol BETabBarButtonDelegate <NSObject>

- (void)tabBarButtonWasSelected:(BETabBarButton *)barButton;

@end
