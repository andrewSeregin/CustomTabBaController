//
//  PlayerTabBarViewController.m
//  iTunesTransition_ObjC
//
//  Created by Andrew Seregin on 19.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "PlayerView.h"
#import "PlayerTabBarViewController.h"
#import "TrackDetailsViewController.h"

@interface PlayerTabBarViewController ()

@end

@implementation PlayerTabBarViewController

- (UIView *)newExtendableView {
    return [PlayerView new];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (BEExtensibleViewController *)extensibleViewController {
    return [TrackDetailsViewController new];
}


@end
