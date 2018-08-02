//
//  AppDelegate.m
//  CustomTabBaController
//
//  Created by Andrew Seregin on 24.07.2018.
//  Copyright © 2018 Andrew Seregin. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerTabBarViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) BEExtendedTabBarController *rootViewController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIViewController *brownViewController = [UIViewController new];
    brownViewController.view.backgroundColor = UIColor.brownColor;
    
    UIViewController *redViewController = [UIViewController new];
    redViewController.view.backgroundColor = UIColor.redColor;
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"Buton" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];

    button.translatesAutoresizingMaskIntoConstraints = NO;
    [brownViewController.view addSubview:button];
    [NSLayoutConstraint activateConstraints:@[[button.centerXAnchor constraintEqualToAnchor:brownViewController.view.centerXAnchor],
                                              [button.centerYAnchor constraintEqualToAnchor:brownViewController.view.centerYAnchor]]];
    
    
    BETabBarItem *itemOne = [[BETabBarItem alloc] initWithTitle:@"window"
                                                          image:[UIImage imageNamed:@"window"]];
    BETabBarItem *itemTwo = [[BETabBarItem alloc] initWithTitle:@"paper_piece"
                                                          image:[UIImage imageNamed:@"paper_piece"]];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    BEExtendedTabBarController  *rootViewController = [PlayerTabBarViewController new];
    [rootViewController configureWithViewControllers:@[redViewController,
                                                       brownViewController]
                                         tabBarItems:@[itemOne,
                                                       itemTwo]];
    
    self.rootViewController = rootViewController;
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    

    return YES;
}

- (void)handleTap {
    [self.rootViewController setExtendableViewHidden:!self.rootViewController.extendableView.isHidden
                                            animated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
