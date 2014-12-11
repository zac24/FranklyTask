//
//  AppDelegate.h
//  Frankly_task
//
//  Created by Prashant Dwivedi on 11/12/14.
//  Copyright (c) 2014 Prashant Dwivedi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTableViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PostTableViewController *postTableViewController;

@end
