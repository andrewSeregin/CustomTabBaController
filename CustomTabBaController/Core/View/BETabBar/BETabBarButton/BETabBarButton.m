//
//  BETabBarButton.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BETabBarButton.h"

#import "BEExtendedTabBarControlleConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface BETabBarButton ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) NSLayoutConstraint *imageContainerViewHeight;

@end

NS_ASSUME_NONNULL_END

@implementation BETabBarButton

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        self.titleLabel = [UILabel new];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.stackView = [self newStackView];
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.stackView];
        [NSLayoutConstraint activateConstraints:@[[self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                  [self.stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]]];
    }
    
    return self;
}

- (instancetype)initFromTabBarItem:(BETabBarItem *)item {
    
    self = [self init];
    if (self) {
        self.imageView.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.titleLabel.text = item.title;
    }
    
    return self;
}

- (UIStackView *)newStackView {
    
    UIView *imageContainerView = [UIView new];
    [imageContainerView addSubview:self.imageView];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageContainerViewHeight = [imageContainerView.heightAnchor constraintEqualToConstant:BETabBarButtonImageSizeVertical];
    [NSLayoutConstraint activateConstraints:@[[self.imageView.centerXAnchor constraintEqualToAnchor:imageContainerView.centerXAnchor],
                                              [self.imageView.centerYAnchor constraintEqualToAnchor:imageContainerView.centerYAnchor],
                                              [self.imageView.heightAnchor constraintEqualToAnchor:imageContainerView.heightAnchor],
                                              [self.imageView.widthAnchor constraintEqualToAnchor:self.imageView.heightAnchor],
                                              [imageContainerView.widthAnchor constraintGreaterThanOrEqualToAnchor:self.imageView.widthAnchor],
                                              self.imageContainerViewHeight]];
    
    UIStackView *stackView = [UIStackView new];
    [stackView setUserInteractionEnabled:NO];

    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView addArrangedSubview:imageContainerView];
    [stackView addArrangedSubview:self.titleLabel];
    
    return stackView;
    
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.titleLabel.textColor = self.tintColor;
    self.imageView.tintColor = self.tintColor;
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    self.titleLabel.textColor = selected ? self.selectedTintColor : self.tintColor;
    self.imageView.tintColor = selected ? self.selectedTintColor : self.tintColor;
}

- (void)orientationChanged:(UIDeviceOrientation)orientation {

    if (orientation == UIDeviceOrientationPortrait) {
        self.stackView.axis = UILayoutConstraintAxisVertical;
        self.stackView.spacing = BETabBarButtonSpacingVertical;
        self.imageContainerViewHeight.constant = BETabBarButtonImageSizeVertical;
        self.titleLabel.font = [UIFont systemFontOfSize:BETabBarButtonFontSizeVertical];
    } else {
        self.stackView.axis = UILayoutConstraintAxisHorizontal;
        self.stackView.spacing = BETabBarButtonSpacingHorizontal;
        self.imageContainerViewHeight.constant = BETabBarButtonImageSizeHorizontal;
        self.titleLabel.font = [UIFont systemFontOfSize:BETabBarButtonFontSizeHorizontal];
    }
}


@end
