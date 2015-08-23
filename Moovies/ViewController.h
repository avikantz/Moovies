//
//  ViewController.h
//  Moovies
//
//  Created by Avikant Saini on 8/23/15.
//  Copyright © 2015 avikantz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JWCTableView.h"
#import "AddViewController.h"
#import "GeneratorViewController.h"
#import "InformationViewController.h"

@interface ViewController : NSViewController <JWCTableViewDataSource, JWCTableViewDelegate, AddViewControllerDelegate, GeneratorDelegate>

@property (weak) IBOutlet JWCTableView *tableView;
@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSButton *generateButton;

@property (weak) IBOutlet NSTextField *informationField;


@end

