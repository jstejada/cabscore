//
//  ServiceController.h
//  CabScore
//
//  Created by Juan Tejada on 4/22/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServiceController : UIViewController {
	IBOutlet UIButton *acceptButton;
	NSDictionary *servicio;
}
@property (nonatomic, retain) NSDictionary *servicio;

- (IBAction) confirmarServicio;

@end
