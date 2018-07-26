//
//  BETabBarButton.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BETabBarButtonDelegate.h"


@interface BETabBarButton : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIColor *selectionTintColor;

@property (nonatomic, weak) id<BETabBarButtonDelegate> delegate;

- (instancetype)init;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

- (void)select;
- (void)deselect;

@end
