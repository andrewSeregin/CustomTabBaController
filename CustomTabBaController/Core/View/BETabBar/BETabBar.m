//
//  BETabBar.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BETabBar.h"

#import "BEExtendedTabBarController.h"

@interface BETabBar ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) NSLayoutConstraint *stackViewHeightConstraint;

@property (nonatomic, weak) BETabBarButton *selectedButton;
@property (nonatomic, strong) BEBarBackground *barBackground;
@property (nonatomic, strong) NSArray<BETabBarButton *> *tabBarButtons;

@end


@implementation BETabBar

#pragma mark - Initialization

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.tintColor = UIColor.blueColor;
        self.selectionTintColor = UIColor.darkGrayColor;
        [self setUpBarBackground];
        [self setUpStackView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - Set Up

- (void)setUpBarBackground {
    
    self.barBackground = [[BEBarBackground alloc] init];
    
    [self addSubview:self.barBackground];
    self.barBackground.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[self.barBackground.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                                              [self.barBackground.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                                              [self.barBackground.topAnchor constraintEqualToAnchor:self.topAnchor],
                                              [self.barBackground.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]]];
}

- (void)setUpStackView {
    
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


#pragma mark - Get/Set Methods

- (void)setItems:(NSArray<BETabBarItem *> *)items {
    
    for (BETabBarButton *anTabBarButton in self.tabBarButtons) {
        [self.stackView removeArrangedSubview:anTabBarButton];
    }
    _items = items;
    [self updateTabBarItems];
}

- (void)setSelectedItem:(BETabBarItem *)selectedItem {
    _selectedItem = selectedItem;
    BETabBarButton *barButton = (BETabBarButton *)self.stackView.arrangedSubviews[[self.items indexOfObject:selectedItem]];
    [self didSelectButton:barButton];
}

#pragma mark - Regular Methods

- (void)didSelectButton:(id)sender {
    
    if ([sender isKindOfClass:BETabBarButton.class]) {
        BETabBarButton* item = (BETabBarButton *)sender;
        
        if (![self.selectedButton isEqual:item]) {
            [item setSelected:YES];
            NSArray<BETabBarButton *> *tabBarButtons = (NSArray<BETabBarButton *> *)self.stackView.arrangedSubviews;
            
            NSInteger index = [tabBarButtons indexOfObject:item];
            if (index != NSNotFound) {
                [self.delegate tabBar:self didSelectItem:[self.items objectAtIndex:index]];
                [self.selectedButton setSelected:NO];
                self.selectedButton = item;
            }
        }
    }
}

-(void)updateTabBarItems {
    
    [self.items enumerateObjectsUsingBlock:^(BETabBarItem * _Nonnull anObjext,
                                             NSUInteger anIndex,
                                             BOOL * _Nonnull stop) {
        
        BETabBarButton *tabBarButton = [[BETabBarButton alloc] initFromTabBarItem:anObjext];
        tabBarButton.tintColor = self.tintColor;
        tabBarButton.selectedTintColor = self.selectionTintColor;
        [tabBarButton addTarget:self
                         action:@selector(didSelectButton:)
               forControlEvents:UIControlEventTouchUpInside];
        
        [self.stackView addArrangedSubview:tabBarButton];
        tabBarButton.translatesAutoresizingMaskIntoConstraints = NO;
        [[tabBarButton.heightAnchor constraintEqualToAnchor:self.stackView.heightAnchor] setActive:YES];
        if (anIndex == 0) {
            [self didSelectButton:tabBarButton];
        } else {
            BETabBarButton *previousTabBarButton = (BETabBarButton *)self.stackView.arrangedSubviews[anIndex - 1];
            [[tabBarButton.widthAnchor constraintEqualToAnchor:previousTabBarButton.widthAnchor] setActive:YES];
        }
    }];
}

- (UIView *)snapshotTabBarWithSeparator:(BOOL)includingSeparator {
    
    UIView *snapshot = [self snapshotViewAfterScreenUpdates:YES];
    UIView *separator = includingSeparator ? [self.barBackground.separatorView snapshotViewAfterScreenUpdates:YES] : nil;
    if (snapshot && separator) {
        [snapshot addSubview:separator];
    }
    
    return snapshot;
}

#pragma mark - Notification Observer Handler

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
