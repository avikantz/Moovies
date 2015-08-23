//
//  AddViewController.m
//  MovieList
//
//  Created by Avikant Saini on 6/15/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	[_categoryField becomeFirstResponder];
}

- (IBAction)addMovie:(id)sender {
	if (![[_categoryField stringValue] isEqualToString:@""] && [[_nameField stringValue] containsString:@"("]) {
		// if the fields are not empty, call the delegate method with the data.
		
		[self.delegate addItemViewController:self didFinishEntereingMovieWithCategory:[_categoryField stringValue] andTitled:[_nameField stringValue]];
		[self dismissController:self];
	}
	else {
		NSAlert *alert = [[NSAlert alloc] init];
		alert.informativeText = [NSString stringWithFormat:@"Invalid movie name format. Category and Movie name should not be blank.\nMovie name format: '<Name> (yyyy)'"];
		alert.messageText = @"Invalid Format";
		[alert addButtonWithTitle:@"Aw Crap."];
		[alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
		}];
	}
}

@end
