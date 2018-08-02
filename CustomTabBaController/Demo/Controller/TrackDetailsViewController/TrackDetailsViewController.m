//
//  TrackDetailsViewController.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 19.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "TrackDetailsViewController.h"

@interface TrackDetailsViewController ()

@property (nonatomic) UIImageView *cover;
@property (nonatomic) UIScrollView *scroll;
@property (nonatomic) UIButton *header;

@property (nonatomic) NSLayoutConstraint *coverTopConstraint;
@property (nonatomic) NSLayoutConstraint *coverLeftConstraint;
@property (nonatomic) NSLayoutConstraint *coverWidthConstraint;
@property (nonatomic) NSLayoutConstraint *coverHeightConstraint;

@property (nonatomic) NSLayoutConstraint *headerTopConstraint;
@property (nonatomic) NSLayoutConstraint *headerLeftConstraint;
@property (nonatomic) NSLayoutConstraint *headerWidthConstraint;
@property (nonatomic) NSLayoutConstraint *headerHeightConstraint;

@end

@implementation TrackDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareContent];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.scroll];
    [self.scroll addSubview:self.cover];
    [self.scroll addSubview:self.header];
    
    [self applyConstraints];
    [self.header addTarget:self
                    action:@selector(handleTapGesture)
          forControlEvents:UIControlEventTouchDragInside];
}

-(void)prepareContent {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover"]];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cover = imageView;
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scroll.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 10);
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    self.scroll = scroll;
    
    UIButton *header = [UIButton new];
    header.layer.cornerRadius = 2;
    header.backgroundColor = UIColor.lightGrayColor;
    header.translatesAutoresizingMaskIntoConstraints = NO;
    self.header = header;
}


- (void)applyConstraints {
    
    self.coverTopConstraint = [self.cover.topAnchor constraintEqualToAnchor:self.scroll.topAnchor constant:10];
    self.coverLeftConstraint = [self.cover.leftAnchor constraintEqualToAnchor:self.scroll.leftAnchor constant:20];
    self.coverWidthConstraint = [self.cover.widthAnchor constraintEqualToConstant:50];
    self.coverHeightConstraint = [self.cover.heightAnchor constraintEqualToConstant:50];
    
    self.headerTopConstraint = [self.header.topAnchor constraintEqualToAnchor:self.scroll.topAnchor constant:0];
    self.headerLeftConstraint = [self.header.leftAnchor constraintEqualToAnchor:self.scroll.leftAnchor constant:0];
    self.headerWidthConstraint = [self.header.widthAnchor constraintEqualToConstant:0];
    self.headerHeightConstraint = [self.header.heightAnchor constraintEqualToConstant:0];
    
    [NSLayoutConstraint activateConstraints:@[self.coverTopConstraint,
                                              self.coverLeftConstraint,
                                              self.coverWidthConstraint,
                                              self.coverHeightConstraint,
                                              self.headerTopConstraint,
                                              self.headerLeftConstraint,
                                              self.headerWidthConstraint,
                                              self.headerHeightConstraint,
                                              [self.scroll.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.scroll.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
                                              [self.scroll.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
                                              [self.scroll.heightAnchor constraintEqualToAnchor:self.view.heightAnchor]]];
    
}

-  (void)animateShrink {
    
    [self.header setHidden:YES];
    self.cover.layer.cornerRadius = 3;
    
    self.coverTopConstraint.constant = 10;
    self.coverLeftConstraint.constant = 20;
    self.coverWidthConstraint.constant = 50;
    self.coverHeightConstraint.constant = 50;
    
    self.headerLeftConstraint.constant = 0;
    self.headerTopConstraint.constant = 0;
    self.headerHeightConstraint.constant = 0;
    self.headerWidthConstraint.constant = 0;
}

- (void)animateExpand {
    
    [self.header setHidden:NO];
    self.headerLeftConstraint.constant = (self.view.bounds.size.width - 100) / 2;
    self.headerTopConstraint.constant = 10;
    self.headerHeightConstraint.constant = 5;
    self.headerWidthConstraint.constant = 100;
    
    CGFloat coverWidth = self.view.bounds.size.width * 0.8;
    self.cover.layer.cornerRadius = 8;
    
    self.coverTopConstraint.constant = 40;
    self.coverLeftConstraint.constant = (self.view.bounds.size.width - coverWidth) / 2;
    self.coverWidthConstraint.constant = coverWidth;
    self.coverHeightConstraint.constant = coverWidth;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

-(void)handleTapGesture {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (nullable UIScrollView *) observableScrollView {
    
    return self.scroll;
}

@end
