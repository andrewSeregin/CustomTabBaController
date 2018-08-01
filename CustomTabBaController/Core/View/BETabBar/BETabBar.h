//
//  BETabBar.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BEExtendedTabBarControlleConstants.h"

#import "BEBarBackground.h"
#import "BETabBarButton.h"
#import "BETabBarDelegate.h"


@interface BETabBar : UIView

@property (nonatomic, strong) UIColor *selectionTintColor;
@property (nonatomic, strong) NSArray<BETabBarItem *> *items;
@property (nonatomic, weak) BETabBarItem *selectedItem;


@property (nonatomic, weak) id<BETabBarDelegate> delegate;

- (UIView *)snapshotTabBarWithSeparator:(BOOL)withSeparator;


@end
