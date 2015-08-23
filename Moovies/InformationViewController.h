//
//  InformationViewController.h
//  MovieList
//
//  Created by Avikant Saini on 6/15/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InformationViewController : NSViewController

@property (weak) IBOutlet NSTextField *movieCountLabel;

@property NSInteger movieCount;

@end
