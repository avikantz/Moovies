//
//  AddViewController.h
//  MovieList
//
//  Created by Avikant Saini on 6/15/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AddViewController;

@protocol AddViewControllerDelegate <NSObject>
- (void)addItemViewController:(AddViewController *)controller didFinishEntereingMovieWithCategory:(NSString *)category andTitled:(NSString *)title;
@end

@interface AddViewController : NSViewController <NSTextFieldDelegate>

@property (nonatomic, weak) id <AddViewControllerDelegate> delegate;

@property (weak) IBOutlet NSTextField *categoryField;

@property (weak) IBOutlet NSTextField *nameField;

- (IBAction)addMovie:(id)sender;


@end
