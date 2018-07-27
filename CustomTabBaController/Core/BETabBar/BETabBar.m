//
//  BETabBar.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BETabBar.h"
#import "BETabBarController.h"

@interface BETabBar ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSLayoutConstraint *stackViewHeightConstraint;

@property (nonatomic, weak) BETabBarButton *selectedItem;
@property (nonatomic, strong) BEBarBackground *barBackground;
@property (nonatomic, strong) NSArray<BETabBarButton *> *tabBarButtons;

@end



@implementation BETabBar

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.tintColor = UIColor.blueColor;
        self.selectionTintColor = UIColor.darkGrayColor;
        [self setupBarBackground];
        [self setupStackView];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
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

- (void)setItems:(NSArray<BETabBarItem *> *)items {

    for (UIView *arrangedSubview in self.items) {
        [self.stackView removeArrangedSubview:arrangedSubview];
    }
    
    _items = items;
    for (int index = 0; index < self.items.count; index++) {
        
        BETabBarButton *current = [[BETabBarButton alloc] initFromTabBarItem:self.items[index]];
        current.tintColor = self.tintColor;
        current.selectionTintColor = self.selectionTintColor;
        
        [current addTarget:self
                    action:@selector(didSelectItem:)
          forControlEvents:UIControlEventTouchUpInside];
        
        [self.stackView addArrangedSubview:current];
        current.translatesAutoresizingMaskIntoConstraints = NO;
        [[current.heightAnchor constraintEqualToAnchor:self.stackView.heightAnchor] setActive:YES];
        if (index == 0) {
            [self didSelectItem:current];
        } else {
            BETabBarButton *previous = (BETabBarButton *)self.stackView.arrangedSubviews[index - 1];
            [[current.widthAnchor constraintEqualToAnchor:previous.widthAnchor] setActive:YES];
        }
    }
}


- (void)didSelectItem:(id)sender {
    
    BETabBarButton* item = (BETabBarButton *)sender;
    [item setSelected:YES];
    
    if (![self.selectedItem isEqual:item]) {
        NSArray<BETabBarButton *> *tabBarButtons = (NSArray<BETabBarButton *> *)self.stackView.arrangedSubviews;
        [self.delegate tabBar:self didSelectItem:[self.items objectAtIndex:[tabBarButtons indexOfObject:item]]];
        [self.selectedItem setSelected:NO];
        self.selectedItem = item;
    }
}

- (void)orientationChanged:(NSNotification *)notification {
    
    UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
    if (UIDeviceOrientationIsValidInterfaceOrientation(orientation)) {
        self.stackViewHeightConstraint.constant = UIDeviceOrientationIsPortrait(orientation) ? BETabBarHeightVertical : BETabBarHeightHorizontal;

        for(BETabBarButton *button in (NSArray<BETabBarButton *> *)self.stackView.arrangedSubviews) {
            [button orientationChanged:orientation];
        }
    }
    
}

@end