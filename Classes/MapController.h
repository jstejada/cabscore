//
//  MapController.h
//  CabScore
//
//  Created by Juan Tejada on 4/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequestDelegate.h"

@interface MapController : UIViewController <MKMapViewDelegate, ASIHTTPRequestDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (IBAction) updateMapAnnotations;
@end
