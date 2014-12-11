//
//  PostTableViewController.m
//  Frankly_task
//
//  Created by Prashant Dwivedi on 11/12/14.
//  Copyright (c) 2014 Prashant Dwivedi. All rights reserved.
//

#import "PostTableViewController.h"

@interface PostTableViewController ()

@end

@implementation PostTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Posts";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
