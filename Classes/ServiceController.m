//
//  ServiceController.m
//  CabScore
//
//  Created by Juan Tejada on 4/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ServiceController.h"
#import "ASIFormDataRequest.h"


@implementation ServiceController
@synthesize servicio;
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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	[servicio release];
    [super dealloc];
}

- (IBAction) confirmarServicio {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://frozen-atoll-4191.herokuapp.com/services/%@.json", [self.servicio objectForKey:@"id"]]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	[request setPostValue:@"4" forKey:@"taxi_id"];
	[request setPostValue:@"confirmado" forKey:@"state"];
	[request setRequestMethod:@"PUT"];
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"El servicio ha sido confirmado" 
														message:@"Por favor verificar el servicio al recoger al pasajero" 
													   delegate:nil 
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self.navigationController popViewControllerAnimated:YES];
	} else {
		NSLog(@"%@",error);
	}
	 
	 
}

@end
