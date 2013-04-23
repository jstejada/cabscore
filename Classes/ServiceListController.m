//
//  ServiceListController.m
//  CabScore
//
//  Created by Juan Tejada on 4/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ServiceListController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "ServiceController.h"

@implementation ServiceListController
@synthesize services;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self updateServices];
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self updateServices];
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return <#number of sections#>;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return services.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Painting cell %d", indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [[self.services objectAtIndex:indexPath.row] objectForKey:@"address"];
	cell.detailTextLabel.text = [[self.services objectAtIndex:indexPath.row] objectForKey:@"state"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
    ServiceController *detailViewController = [[ServiceController alloc] initWithNibName:@"ServiceCOntroller" bundle:nil];
    detailViewController.title = @"Confirmar Servicio";
	
	
    // Pass the selected object to the new view controller.
	detailViewController.servicio = [services objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[services release];
    [super dealloc];
}

- (void) updateServices {
	
	NSURL *url = [NSURL URLWithString:@"http://frozen-atoll-4191.herokuapp.com/services.json"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {		
		JSONDecoder* decoder = [[JSONDecoder alloc]	initWithParseOptions:JKParseOptionNone];
		NSArray *tempArray = [decoder objectWithData:[request responseData]];
		self.services = [[NSMutableArray alloc] init];
		
		for (NSDictionary *obj in tempArray){
			if ([[obj objectForKey:@"state"] isEqualToString:@"pendiente"]){
				[self.services addObject:obj];
			}
		}
		
		NSLog(@"services count: %d",[services count]);
		[decoder release];
	} else {
		NSLog(@"%@",error);
	}
	
}

@end

