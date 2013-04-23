//
//  CabScoreAppDelegate.m
//  CabScore
//
//  Created by Juan Tejada on 4/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "CabScoreAppDelegate.h"
#import "MapController.h"
#import "ServiceListController.h"
#import "PanicController.h"

@implementation CabScoreAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    tabController = [[UITabBarController alloc] init];
	
	//Map Controller
	UINavigationController *mapNavigationController = [[UINavigationController alloc] init];
	MapController *mapController = [[MapController alloc] initWithNibName:@"MapController" bundle:nil];
	mapController.title = @"Mapa";
	mapNavigationController.title = @"Mapa";
	mapNavigationController.tabBarItem.image = [UIImage imageNamed:@"globe.png"];
	[mapNavigationController pushViewController:mapController animated:NO];
	
	
	//Service List controller
	UINavigationController *listNavigationController = [[UINavigationController alloc] init];
	ServiceListController *listController = [[ServiceListController alloc] initWithNibName:@"ServiceListController" bundle:nil];
	listController.title = @"Servicios";
	UITabBarItem *item = [[UITabBarItem alloc] initWithTabBarSystemItem:
						  UITabBarSystemItemRecents tag:0];
	listNavigationController.tabBarItem = item;
	[item release];
	[listNavigationController pushViewController:listController animated:NO];
	
	
	//Panic Controller
	PanicController *panicController = [[PanicController alloc] initWithNibName: @"PanicController" bundle: nil];
	panicController.title = @"Pánico";
	panicController.tabBarItem.image = [UIImage imageNamed:@"panic.png"];
	
	tabController.viewControllers = [NSArray arrayWithObjects:mapNavigationController, listNavigationController, panicController, nil];
	
	[panicController release];
	[mapController release];
	[listController release];
	[listNavigationController release];
	[mapNavigationController release];
	[self.window addSubview:tabController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tabController release];
    [window release];
    [super dealloc];
}


@end
