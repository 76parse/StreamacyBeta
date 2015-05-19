//
//  SATabBarController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/18/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SATabBarController.h"
#import "AppDelegate.h"

@interface SATabBarController ()

@end

@implementation SATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *viewControllersArray = [[NSMutableArray alloc]initWithCapacity:5];
    [viewControllersArray addObject:[[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateInitialViewController]];
    [viewControllersArray addObject:[[UIStoryboard storyboardWithName:@"Playlists" bundle:nil] instantiateInitialViewController]];
    [viewControllersArray addObject:[[UIStoryboard storyboardWithName:@"Stream" bundle:nil] instantiateInitialViewController]];
    [viewControllersArray addObject:[[UIStoryboard storyboardWithName:@"Inbox" bundle:nil] instantiateInitialViewController]];
    [viewControllersArray addObject:[[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateInitialViewController]];

    [self setViewControllers:viewControllersArray];
    
    UIViewController *searchVC = viewControllersArray[0];
    UIImage *tab1Image = [UIImage imageNamed:@"Search.png"];
    UITabBarItem *item1 = [[UITabBarItem alloc]initWithTitle:nil image:tab1Image selectedImage:nil];
    item1.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    searchVC.tabBarItem = item1;

    
    UIViewController *playlistsVC = viewControllersArray[1];
    UIImage *tab2Image = [UIImage imageNamed:@"Playlists.png"];
    UITabBarItem *item2 = [[UITabBarItem alloc]initWithTitle:nil image:tab2Image selectedImage:nil];
    item2.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    playlistsVC.tabBarItem = item2;
    
    UIViewController *streamVC = viewControllersArray[2];
    UIImage *tab3Image = [UIImage imageNamed:@"Stream.png"];
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:nil image:tab3Image selectedImage:nil];
    item3.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    streamVC.tabBarItem = item3;
    
    UIViewController *inboxVC = viewControllersArray[3];
    UIImage *tab4Image = [UIImage imageNamed:@"Inbox.png"];
    UITabBarItem *item4 = [[UITabBarItem alloc]initWithTitle:nil image:tab4Image selectedImage:nil];
    item4.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    inboxVC.tabBarItem = item4;
    
    UIViewController *FriendsVC = viewControllersArray[4];
    UIImage *tab5Image = [UIImage imageNamed:@"Friends.png"];
    UITabBarItem *item5 = [[UITabBarItem alloc]initWithTitle:nil image:tab5Image selectedImage:nil];
    item5.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    FriendsVC.tabBarItem = item5;
    
    UIView *tabView = self.view.subviews.lastObject;
    UIView *purpleLine = [[UIView alloc]initWithFrame:CGRectMake(0, tabView.frame.origin.y-4, self.view.frame.size.width, 4)];
    [purpleLine setBackgroundColor:[UIColor colorWithRed:0.584 green:0.523 blue:0.979 alpha:0.85]];
    NSInteger index = self.view.subviews.count-1;
    [self.view insertSubview:purpleLine atIndex:index];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[AppDelegate imageFromColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.8] forSize:CGSizeMake(64, 49) withCornerRadius:0]];


}


@end
