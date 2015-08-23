//
//  GeneratorViewController.h
//  MovieList
//
//  Created by Avikant Saini on 6/26/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "Item.h"

@class GeneratorViewController;

@protocol GeneratorDelegate <NSObject>

-(void)didFinishExportingData;

@end

@interface GeneratorViewController : NSViewController

@property (weak) IBOutlet AppDelegate *appDelegate;

@property (weak) IBOutlet NSTextField *pathTextField;
- (IBAction)pathTextFieldDidReturn:(id)sender;

@property (nonatomic, retain) id <GeneratorDelegate> delegate;

@property (weak) IBOutlet NSTextField *savedToDesktopLabel;

@property (weak) IBOutlet NSButton *exportButton;
- (IBAction)exportAction:(id)sender;

@end
