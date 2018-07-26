//
//  BETabBarButton.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BETabBarButton.h"
#import "BEConstants.h"

@interface BETabBarButton ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) NSLayoutConstraint *imageContainerViewHeight;
@property (nonatomic, getter=isSelected) BOOL selected;

@end

@implementation BETabBarButton

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.titleLabel.textColor = self.tintColor;
    self.imageView.tintColor = self.tintColor;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTapRecognizer:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tapRecognizer];
        
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.backgroundColor = UIColor.clearColor;

        self.titleLabel = [UILabel new];
        self.titleLabel.backgroundColor = UIColor.clearColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        [self initStackView];
        
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    
    self = [self init];
    if (self) {
        
        self.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.imageView.image = self.image;
        
        self.title = title;
        self.titleLabel.text = self.title;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return self;
}


- (void)handleTapRecognizer:(UITapGestureRecognizer*)tapRecognizer {
    
    if (tapRecognizer.state == UIGestureRecognizerStateRecognized) {
        [self.delegate tabBarButtonWasSelected:self];
    }
}

- (void)select {
    self.titleLabel.textColor = self.selectionTintColor;
    self.imageView.tintColor = self.selectionTintColor;
}

- (void)deselect {
    self.titleLabel.textColor = self.tintColor;
    self.imageView.tintColor = self.tintColor;
}


-(void)initStackView {
    
//    UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
//    if (UIDeviceOrientationIsValidInterfaceOrientation(orientation)) {
    
        UIView *imageContainerView = [UIView new];
        imageContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageContainerViewHeight = [imageContainerView.heightAnchor constraintEqualToConstant:BETabBarButtonImageSizeVertical];
        [NSLayoutConstraint activateConstraints:@[self.imageContainerViewHeight,
                                                  [imageContainerView.widthAnchor constraintEqualToAnchor:imageContainerView.heightAnchor]]];
        
        [imageContainerView addSubview:self.imageView];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[[self.imageView.topAnchor constraintEqualToAnchor:imageContainerView.topAnchor],
                                                  [self.imageView.bottomAnchor constraintEqualToAnchor:imageContainerView.bottomAnchor],
                                                  [self.imageView.leftAnchor constraintEqualToAnchor:imageContainerView.leftAnchor],
                                                  [self.imageView.rightAnchor constraintEqualToAnchor:imageContainerView.rightAnchor]]];
    
        [self.titleLabel sizeToFit];
        self.stackView = [[UIStackView alloc] initWithArrangedSubviews:@[imageContainerView,
                                                                         self.titleLabel]];
        [self addSubview:self.stackView];
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[[self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
                                                  [self.stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]]];
//    }
}

- (void)layoutSubviews {
    
    UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
//    if (UIDeviceOrientationIsValidInterfaceOrientation(orientation)) {
    self.stackView.axis = UIDeviceOrientationIsPortrait(orientation) ? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
    self.stackView.spacing = UIDeviceOrientationIsPortrait(orientation) ? BETabBarButtonSpacingVertical : BETabBarButtonSpacingHorizontal;
    self.imageContainerViewHeight.constant = UIDeviceOrientationIsPortrait(orientation) ? BETabBarButtonImageSizeVertical : BETabBarButtonImageSizeHorizontal;
    
    self.titleLabel.font = [UIFont systemFontOfSize:BETabBarButtonFontSizeVertical];
    [self.titleLabel sizeToFit];
    [self.stackView layoutIfNeeded];
    
    [super layoutSubviews];
}

@end
