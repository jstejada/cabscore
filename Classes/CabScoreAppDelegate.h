//
//  CabScoreAppDelegate.h
//  CabScore
//
//  Created by Juan Tejada on 4/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CabScoreAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

