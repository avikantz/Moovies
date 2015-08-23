//
//  InformationViewController.m
//  MovieList
//
//  Created by Avikant Saini on 6/15/15.
//  Copyright (c) 2015 avikantz. All rights reserved.
//

#import "InformationViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
	
	self.movieCountLabel.stringValue = [NSString stringWithFormat:@"%li", self.movieCount];
}

@end
