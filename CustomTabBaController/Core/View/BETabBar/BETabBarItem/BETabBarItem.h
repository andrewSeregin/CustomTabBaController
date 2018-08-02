//
//  BETabBarItem.h
//  CustomTabBaController
//
//  Created by Andrew Seregin on 27.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BETabBarItem : NSObject

@property (nonatomic, nullable, strong) UIImage *image;
@property (nonatomic, nullable, strong) NSString *title;

NS_ASSUME_NONNULL_BEGIN

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;

NS_ASSUME_NONNULL_END

@end
