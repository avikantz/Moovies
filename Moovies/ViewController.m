//
//  ViewController.m
//  Moovies
//
//  Created by Avikant Saini on 8/23/15.
//  Copyright © 2015 avikantz. All rights reserved.
//

#import "ViewController.h"
#import "CategoryCellView.h"
#import "MovieCellView.h"

@implementation ViewController {
	NSMutableDictionary *Movies;
	NSMutableArray *Categories;
	NSMutableArray *FullList;
	NSInteger movieCount;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	
	self.tableView.jwcTableViewDataSource = self;
	self.tableView.jwcTableViewDelegate = self;
	
	if ([NSData dataWithContentsOfFile:[self documentsPathForFileName:@"Movies.dat"]])
		Movies = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[self documentsPathForFileName:@"Movies.dat"]] options:kNilOptions error:nil];
	else
		Movies = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"MoviesArray" ofType:@"json"]] options:kNilOptions error: nil];
	
	Categories = [[NSMutableArray alloc] initWithArray:[[Movies allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
	
	NSMutableDictionary *Movies2 = [[NSMutableDictionary alloc] init];
	for (NSString *key in Movies) {
		NSMutableArray *Array2 = [[NSMutableArray alloc] init];
		for (NSString *value in Movies[key])
			[Array2 addObject:value];
		if ([key length] == 1) {
			NSArray *sortedArray2 = [Array2 sortedArrayUsingComparator:^(NSString *a, NSString *b){
				return [a caseInsensitiveCompare:b];
			}];
			[Movies2 setObject:sortedArray2 forKey:key];
		}
		else {
			NSArray *sortedArray2 = [Array2 sortedArrayUsingComparator:^(NSString *a, NSString *b){
				NSString *aa = [a substringWithRange:NSMakeRange([a length] - 5, 4)];
				NSString *bb = [b substringWithRange:NSMakeRange([b length] - 5, 4)];
				if ([aa compare:bb] == NSOrderedAscending)
					return NSOrderedAscending;
				return NSOrderedDescending;
			}];
			[Movies2 setObject:sortedArray2 forKey:key];
		}
	}
	Movies = [NSMutableDictionary dictionaryWithDictionary:Movies2];
	
	[self populateFullList];
	[self writeData];
	[self.tableView reloadData];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

-(void)didFinishExportingData {
	[self viewDidLoad];
}

#pragma mark - Add and Delete

-(void)addItemViewController:(AddViewController *)controller didFinishEntereingMovieWithCategory:(NSString *)category andTitled:(NSString *)title {
	BOOL isMovieAlreadyPresent = NO;
	for (NSString *movie in FullList)
		if ([movie isEqualToString:title])
			isMovieAlreadyPresent = YES;
	
	if (isMovieAlreadyPresent) {
		NSAlert *alert = [[NSAlert alloc] init];
		alert.informativeText = [NSString stringWithFormat:@"'%@' is already present in the list! No use of adding it again.", title];
		alert.messageText = @"Already present.";
		[alert addButtonWithTitle:@"Okie Dokie!"];
		[alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
			
		}];
	}
	else {
		NSLog(@"\nMovie added : '%@'\tin section : '%@'", title, category);
		NSMutableDictionary *Movies2 = [[NSMutableDictionary alloc] init];
		BOOL keyAlreadyPresent = NO;
		for (NSString *key in Movies) {
			NSMutableArray *Array2 = [[NSMutableArray alloc] init];
			for (NSString *value in Movies[key]) {
				[Array2 addObject:value];
			}
			if ([key isEqualToString:category]) {
				[Array2 addObject:title];
				keyAlreadyPresent = YES;
			}
			if ([key length] == 1) {
				NSArray *sortedArray2 = [Array2 sortedArrayUsingComparator:^(NSString *a, NSString *b){
					return [a caseInsensitiveCompare:b];
				}];
				[Movies2 setObject:sortedArray2 forKey:key];
			}
			else {
				NSArray *sortedArray2 = [Array2 sortedArrayUsingComparator:^(NSString *a, NSString *b){
					NSString *aa = [a substringWithRange:NSMakeRange([a length] - 5, 4)];
					NSString *bb = [b substringWithRange:NSMakeRange([b length] - 5, 4)];
					if ([aa compare:bb] == NSOrderedAscending)
						return NSOrderedAscending;
					return NSOrderedDescending;
				}];
				[Movies2 setObject:sortedArray2 forKey:key];
			}
		}
		if (!keyAlreadyPresent) {
			[Movies2 setObject:[[NSMutableArray alloc] initWithArray:@[title]] forKey:category];
			[Categories addObject:category];
			[Categories sortUsingSelector:@selector(caseInsensitiveCompare:)];
		}
		Movies = Movies2;
		[self populateFullList];
		[self writeData];
		[self.tableView reloadData];
	}
}

-(void)keyDown:(nonnull NSEvent *)theEvent {
	unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	if(key == NSDeleteCharacter) {
		NSIndexPath *indexPath = _tableView.selectedIndexPath;
		if (indexPath != nil) {
			NSString *cellTitle = [Movies[Categories[indexPath.section]] objectAtIndex:indexPath.row];
			NSMutableDictionary *Movies2 = [[NSMutableDictionary alloc] init];
			NSAlert *alert = [[NSAlert alloc] init];
			alert.messageText = @"Delete?";
			alert.informativeText = [NSString stringWithFormat:@"Delete '%@' from category '%@'?", cellTitle, Categories[indexPath.section]];
			[alert addButtonWithTitle:@"Do it."];
			[alert addButtonWithTitle:@"Cancel"];
			[alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
				if (returnCode == NSAlertFirstButtonReturn) {
					NSLog(@"\nMovie deleted : '%@' from section : '%@'", cellTitle, Categories[indexPath.section]);
					for (NSString *key in Movies) {
						NSMutableArray *Array2 = [[NSMutableArray alloc] init];
						for (NSString *value in Movies[key]) {
							if (![value isEqualToString:cellTitle]) {
								[Array2 addObject:value];
							}
						}
						if (Array2.count > 0)
							[Movies2 setObject:Array2 forKey:key];
					}
					Movies = Movies2;
					[self populateFullList];
					[self writeData];
					[self.tableView reloadData];
				}
			}];
		}
	}
	[super keyDown:theEvent];
}

#pragma mark -  JWCTableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(NSTableView *)tableView {
	return Categories.count;
}

-(NSInteger)tableView:(NSTableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *sectionTitle = [Categories objectAtIndex:section];
	NSArray *sectionx = [Movies objectForKey:sectionTitle];
	return [sectionx count];
}

-(BOOL)tableView:(NSTableView *)tableView hasHeaderViewForSection:(NSInteger)section {
	return YES;
}

-(CGFloat)tableView:(NSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 26.f;
}

-(CGFloat)tableView:(NSTableView *)tableView heightForHeaderViewForSection:(NSInteger)section {
	return 36.f;
}

-(NSView *)tableView:(NSTableView *)tableView viewForHeaderInSection:(NSInteger)section {
	CategoryCellView *ccv = [self.tableView makeViewWithIdentifier:@"categoryCell" owner:self];
	NSString *sectionTitle = [Categories objectAtIndex:section];
	NSInteger count = [[Movies objectForKey:sectionTitle] count];
	ccv.textField.stringValue = [sectionTitle uppercaseString];
	ccv.countField.stringValue = [NSString stringWithFormat:@"%li", count];
	return ccv;
}

-(NSView *)tableView:(NSTableView *)tableView viewForIndexPath:(NSIndexPath *)indexPath {
	MovieCellView *mcv = [self.tableView makeViewWithIdentifier:@"movieCell" owner:self];
	NSString *sectionTitle = [Categories objectAtIndex:indexPath.section];
	NSArray *sectionx = [Movies objectForKey:sectionTitle];
	NSString *movieTitle = [sectionx objectAtIndex:indexPath.row];
	mcv.textField.stringValue = movieTitle;
	return mcv;
}

#pragma mark -  JWCTableViewDelegate methods

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectSection:(NSInteger)section {
	return YES;
}

#pragma mark - Utility

- (NSString *)documentsPathForFileName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [NSString stringWithFormat:@"%@/Listing (Mac)", [paths objectAtIndex:0]];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil];
	return [documentsPath stringByAppendingPathComponent:name];
}

-(void) populateFullList {
	movieCount = 0;
	Categories = [NSMutableArray arrayWithArray:[[Movies allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
	FullList = [[NSMutableArray alloc] init];
	for (NSString *key in Movies) {
		for (NSString *key2 in Movies[key]) {
			[FullList addObject:[NSString stringWithFormat:@"%@", key2]];
			++movieCount;
		}
	}
	FullList = [NSMutableArray arrayWithArray:[FullList sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
	_informationField.stringValue = [NSString stringWithFormat:@"%li MOOVIES", movieCount];
	self.title = [NSString stringWithFormat:@"%li MOOVIES", movieCount];
}

-(void) writeData {
	NSData *data = [NSJSONSerialization dataWithJSONObject:Movies options:kNilOptions error:nil];
	[data writeToFile:[self documentsPathForFileName:[NSString stringWithFormat:@"Movies.dat"]] atomically:YES];
}


#pragma mark - Navigation

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"InformationSegue"]) {
		InformationViewController *ivt = [segue destinationController];
		ivt.movieCount = movieCount;
	}
	if ([segue.identifier isEqualToString:@"AddMovieSegue"]) {
		AddViewController *avc = [segue destinationController];
		avc.delegate = self;
	}
	if ([segue.identifier isEqualToString:@"GeneratorSegue"]) {
		GeneratorViewController *gvc = [segue destinationController];
		gvc.delegate = self;
	}
}

@end
