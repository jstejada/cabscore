//
//  ServiceListController.h
//  CabScore
//
//  Created by Juan Tejada on 4/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequestDelegate.h"

@interface ServiceListController : UITableViewController
@property (nonatomic, retain) NSMutableArray * services;

- (void) updateServices;
- (void) updateAndReload;
@end
