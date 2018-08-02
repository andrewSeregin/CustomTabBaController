//
//  PlayerView.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 18.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "PlayerView.h"

@interface PlayerView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PlayerView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 90, 90)];
    
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover"]];
        _imageView.layer.shadowOpacity = 0.3;
        _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _imageView.layer.shadowOffset = CGSizeMake(3, 3);
        _imageView.layer.shadowRadius = 10;
        _imageView.layer.cornerRadius = 3;
        _imageView.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:_imageView];
        
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[[_imageView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10],
                                                  [_imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:20],
                                                  [_imageView.heightAnchor constraintEqualToConstant:50],
                                                  [_imageView.widthAnchor constraintEqualToConstant:50]]];
        
    }
    return self;
}


@end
