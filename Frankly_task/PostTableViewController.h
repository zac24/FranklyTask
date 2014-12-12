//
//  PostTableViewController.h
//  Frankly_task
//
//  Created by Prashant Dwivedi on 11/12/14.
//  Copyright (c) 2014 Prashant Dwivedi. All rights reserved.
//

/*!
 *  @brief Provides the client for App.net that just lists most recent posts from timeline.
 *
 *  Set of methods for calling API and Pull to Refresh Implementation
 *
 *  @note This class uses third party libraries.
 *       AFNetworking -- for contacting with server and getting the desired data.
 *       SBJson  -- SBJson has been used to parse the data in JSON format.
 *       AsynchImageView -- for loading Imges Asynchronously from server.
 */

#import <UIKit/UIKit.h>

@interface PostTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UITableView *postTableView;
@property (nonatomic, strong) NSArray *postDataArray;
@property (nonatomic, strong) NSMutableArray *tmpPostDataArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
