//
//  MapController.m
//  CabScore
//
//  Created by Juan Tejada on 4/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MapController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "ServiceController.h"


@implementation MapController
@synthesize mapView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.mapView.delegate = self;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


// <MKMapViewDelegate>
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
	
	[self updateMapAnnotations];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if ([[annotation title] isEqualToString:@"Current Location"]) {    
        return nil;
    }
	
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    if ([[annotation subtitle] isEqualToString:@"accidente"] || [[annotation subtitle] isEqualToString:@"trancon"])
		annView.image = [ UIImage imageNamed:@"map_traffic_jam.png" ];
    else if ([[annotation subtitle] isEqualToString:@"hueco"])
		annView.image = [ UIImage imageNamed:@"map_hole.png" ];
	else if ([[annotation title] isEqualToString:@"Servicio"]){
		annView.image = [ UIImage imageNamed:@"map_user.png" ];
		UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];   
		[infoButton addTarget:self action:@selector(showDetailsView) forControlEvents:UIControlEventTouchUpInside];
		annView.rightCalloutAccessoryView = infoButton;
	}
		
	
    annView.canShowCallout = YES;
    return [annView autorelease];
}

- (IBAction) updateMapAnnotations {
	
	NSURL *url = [NSURL URLWithString:@"http://frozen-atoll-4191.herokuapp.com/map_objects.json"];
	ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:url];
	[request1 setDelegate:self];
	request1.userInfo = [NSDictionary dictionaryWithObject:@"map_object" forKey:@"type"];
	[request1 startAsynchronous];
	
	url = [NSURL URLWithString:@"http://frozen-atoll-4191.herokuapp.com/services.json"];
	ASIHTTPRequest *request2 = [ASIHTTPRequest requestWithURL:url];
	[request2 setDelegate:self];
	request2.userInfo = [NSDictionary dictionaryWithObject:@"service" forKey:@"type"];
	[request2 startAsynchronous];
	
}


- (void) requestFinished:(ASIHTTPRequest *)request {
	
	JSONDecoder* decoder = [[JSONDecoder alloc]
							initWithParseOptions:JKParseOptionNone];
	NSArray* json = [decoder objectWithData:[request responseData]];
	
	for (NSDictionary *obj in json){
				
		// Add anotations
		MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
		
		if ([[request.userInfo objectForKey:@"type"] isEqualToString: @"map_object"]){
			NSString *latitude = [NSString stringWithFormat:@"%@", [obj objectForKey:@"latitude"]];
			NSString *longitude = [NSString stringWithFormat:@"%@", [obj objectForKey:@"longitude"]];
			CLLocationCoordinate2D coord = {
				latitude.floatValue, longitude.floatValue
			};
			point.coordinate = coord;
			
			point.title = @"Info!";
			point.subtitle = [NSString stringWithFormat:@"%@", [obj objectForKey:@"category"]];
			[self.mapView addAnnotation:point];
		} else {
			if ([[obj objectForKey:@"state"] isEqualToString:@"pendiente"]) {
				BSForwardGeocoder *forwardGeocoder = [[BSForwardGeocoder alloc] init];
				[forwardGeocoder forwardGeocodeWithQuery:[NSString stringWithFormat:@"%@, Bogota, Colombia", [obj objectForKey:@"address"]] regionBiasing:nil viewportBiasing:nil success:^(NSArray *results) {
					BSKmlResult *place = [results objectAtIndex:0];
					point.coordinate = place.coordinate;
					point.title = @"Servicio";
					point.subtitle =[NSString stringWithFormat:@"%@", [obj objectForKey:@"address"]];
					[self.mapView addAnnotation:point];
				} failure:^(int status, NSString *errorMessage) {
					NSLog(@"Error %@", errorMessage);
				}];
				[forwardGeocoder release];
			}
		}
		[point release];
	}
	
	[decoder release];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	NSLog(@"%@",error);
}

- (void)showDetailsView {
	ServiceController *detailViewController = [[ServiceController alloc] initWithNibName:@"ServiceCOntroller" bundle:nil];
    detailViewController.title = @"Confirmar Servicio";
	
    // Pass the selected object to the new view controller.
	//detailViewController.servicio = [services objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	
}

@end
