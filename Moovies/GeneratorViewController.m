//
//  GeneratorViewController.m
//  MovieList
//
//  Created by Avikant Saini on 6/26/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "GeneratorViewController.h"

@interface GeneratorViewController ()

@end

@implementation GeneratorViewController {
	NSMutableDictionary *movieList;
	NSMutableArray *moviesInCategory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	_exportButton.hidden = YES;
	
	_savedToDesktopLabel.stringValue = @"Enter path of the root \"Movies\" directory.";
	
	if ([[NSUserDefaults standardUserDefaults] valueForKey:@"lastEditedPath"])
		_pathTextField.stringValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastEditedPath"];
	
}

-(void)pathTextFieldDidReturn:(id)sender {
	
	[[NSUserDefaults standardUserDefaults] setObject:_pathTextField.stringValue forKey:@"lastEditedPath"];
	
	movieList = [[NSMutableDictionary alloc] init];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *contents = [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@", _pathTextField.stringValue] error:nil];

	[contents enumerateObjectsUsingBlock:^(NSString *categoryName, NSUInteger idx, BOOL *stop) {
		if ([categoryName hasPrefix:@"."] || [categoryName containsString:@"Icon"])
			return;
		
		Item *item = [[Item alloc] init];
		item.itemPath = [[NSString stringWithFormat:@"%@", _pathTextField.stringValue] stringByAppendingPathComponent:categoryName];
		
		moviesInCategory = [[NSMutableArray alloc] init];
		
		if ([item.itemKind isEqualToString:@"Folder"]) {
			
			NSArray *subcontents = [manager contentsOfDirectoryAtPath:item.itemPath error:nil];
			
			[subcontents enumerateObjectsUsingBlock:^(NSString *movieName, NSUInteger idx, BOOL *stop) {
				
				if (!([movieName hasPrefix:@"."] || [movieName containsString:@"Icon"])) {
					
					Item *subItem = [[Item alloc] init];
					subItem.itemPath = [item.itemPath stringByAppendingPathComponent:movieName];
					
					if ([subItem.itemDisplayName containsString:@"("])
						[moviesInCategory addObject:[NSString stringWithFormat:@"%@", subItem.itemDisplayName]];
				}
			}];
			
		}
		[moviesInCategory sortUsingComparator:^(NSString *a, NSString *b){
			NSString *aa = [a substringWithRange:NSMakeRange([a length] - 5, 4)];
			NSString *bb = [b substringWithRange:NSMakeRange([b length] - 5, 4)];
			if ([aa compare:bb] == NSOrderedAscending)
				return NSOrderedAscending;
			return NSOrderedDescending;
		}];
		
		[movieList setObject:moviesInCategory forKey:categoryName];
		
	}];
	
	NSLog(@"%@", movieList);

	if (movieList) {
		NSData *data = [NSJSONSerialization dataWithJSONObject:movieList options:kNilOptions error:nil];
		[data writeToFile:[self desktopPathForFileName:@"Movies.dat"] atomically:YES];
		_savedToDesktopLabel.stringValue = @"File saved to ~/Desktop/Movies.dat";
		_exportButton.hidden = NO;
	}
}

-(void)exportAction:(id)sender {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *filepath = [[NSString stringWithFormat:@"%@/Listing (Mac)/", [paths lastObject]] stringByAppendingPathComponent:@"Movies.dat"];
	NSData *data = [NSJSONSerialization dataWithJSONObject:movieList options:kNilOptions error:nil];
	[data writeToFile:filepath atomically:YES];
	[self.delegate didFinishExportingData];
	[self dismissController:self];
}

- (NSString *)desktopPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [NSString stringWithFormat:@"%@", [paths lastObject]];
	return [documentsPath stringByAppendingPathComponent:name];
}

@end
