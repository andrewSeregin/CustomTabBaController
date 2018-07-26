//
//  BETabBar.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BETabBar.h"


@interface BETabBar ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSLayoutConstraint *stackViewHeightConstraint;

@property (nonatomic, strong) BEBarBackground *barBackground;
@property (nonatomic, weak) BETabBarButton *selectedItem;

@end

@implementation BETabBar

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.tintColor = UIColor.blueColor;
        self.selectionTintColor = UIColor.darkGrayColor;
        [self setupBarBackground];
        [self setupStackView];
    }
    
    return self;
}

- (void)setupBarBackground {
    
    self.barBackground = [[BEBarBackground alloc] init];
    
    [self addSubview:self.barBackground];
    self.barBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[self.barBackground.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                                              [self.barBackground.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                                              [self.barBackground.topAnchor constraintEqualToAnchor:self.topAnchor],
                                              [self.barBackground.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]]];
}

- (void)setupStackView {
    
    if (!self.stackView) {
        self.stackView = [UIStackView new];
        [self addSubview:self.stackView];
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        self.stackViewHeightConstraint = [self.stackView.heightAnchor constraintEqualToConstant:BETabBarHeightVertical];
        [NSLayoutConstraint activateConstraints:@[[self.stackView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                                                  [self.stackView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                                                  [self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
                                                  self.stackViewHeightConstraint]];
    }
    
}

- (void)setItems:(NSArray<BETabBarButton *> *)items {
    
    for (UIView *arrangedSubview in self.items) {
        [self.stackView removeArrangedSubview:arrangedSubview];
    }
    
    _items = items;
    for (int i = 0; i < self.items.count; i++) {
        BETabBarButton *currentItem = self.items[i];
        currentItem.delegate = self;
        currentItem.tintColor = self.tintColor;
        currentItem.selectionTintColor = self.selectionTintColor;
        [self.stackView addArrangedSubview:currentItem];
        NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray arrayWithObject:[currentItem.heightAnchor constraintEqualToAnchor:self.stackView.heightAnchor]];
        if (i > 0) {
            UIView *previousItem = self.items[i-1];
            [constraints addObject:[currentItem.widthAnchor constraintEqualToAnchor:previousItem.widthAnchor]];
        }
        currentItem.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:constraints];
    }
    
}

- (void)tabBarButtonWasSelected:(BETabBarButton *)barButton {
    
    if (![self.selectedItem isEqual:barButton]) {
        
        [self.delegate tabBar:self requestReloadingViewForSelectedItem:barButton];
        [self.selectedItem deselect];
        [barButton select];
        self.selectedItem = barButton;
    }
}
- (void)layoutSubviews {

    self.stackViewHeightConstraint.constant = UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation) ? BETabBarHeightVertical : BETabBarHeightHorizontal;
    [super layoutSubviews];
}

@end
