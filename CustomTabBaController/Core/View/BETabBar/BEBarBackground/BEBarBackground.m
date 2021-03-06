//
//  BEBarBackground.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "BEBarBackground.h"


NS_ASSUME_NONNULL_BEGIN

@implementation BEBarBackground

#pragma mark - Initialization

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.clearsContextBeforeDrawing = YES;
        [self setUpSeporator];
        [self setUpEffectView];
    }
    return self;
}

#pragma mark - Set Up

- (void)setUpSeporator {
    self.separatorView = [UIView new];
    [self.separatorView setBackgroundColor:[UIColor colorWithWhite:.7f alpha:1.f]];
    
    [self addSubview:self.separatorView];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[self.separatorView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                                              [self.separatorView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                                              [self.separatorView.bottomAnchor constraintEqualToAnchor:self.topAnchor],
                                              [self.separatorView.heightAnchor constraintEqualToConstant:0.7f]]];
}

- (void)setUpEffectView {
    
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self addSubview:self.effectView];
    self.effectView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[[self.effectView.leftAnchor constraintEqualToAnchor:self.leftAnchor],
                                              [self.effectView.rightAnchor constraintEqualToAnchor:self.rightAnchor],
                                              [self.effectView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
                                              [self.effectView.topAnchor constraintEqualToAnchor:self.topAnchor]]];
}

@end

NS_ASSUME_NONNULL_END
