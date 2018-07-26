//
//  BETabBar.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEConstants.h"
#import "BETabBarButton.h"
#import "BEBarBackground.h"
#import "BETabBarButtonDelegate.h"
#import "BETabBarDelegate.h"

@interface BETabBar : UIView<BETabBarButtonDelegate>

@property (nonatomic, strong) UIColor *selectionTintColor;
@property (nonatomic, strong) NSArray<BETabBarButton *> *items;
@property (nonatomic, weak) id<BETabBarDelegate> delegate;

- (void)setItems:(NSArray<BETabBarButton *> *)items;

@end
