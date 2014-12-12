//
//  PostTableViewController.m
//  Frankly_task
//
//  Created by Prashant Dwivedi on 11/12/14.
//  Copyright (c) 2014 Prashant Dwivedi. All rights reserved.
//

#import "PostTableViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PostTableViewController ()

@end

@implementation PostTableViewController

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define CORNER_RADIUS 14.0f
#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 55.0f

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
    
    self.title = @"Timeline Posts";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Nueue" size:22.0], NSFontAttributeName,nil]];
    
    self.tmpPostDataArray = [[NSMutableArray alloc]init];
    
// ====================  Implementation for Pull to Refresh =====================
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh..."]; //to give the attributedTitle
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.postTableView addSubview:self.refreshControl];
    
// ====================  Spinner Implementation ===============================
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 250, 20, 30)];
    [self.spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.spinner setColor:[UIColor blackColor]];
    [self.view addSubview:self.spinner];

// ================== Making 3.5" screen Compatible ===========================
    if (!isiPhone5) {
        [self.postTableView setFrame:CGRectMake(0, 0, 320, 480)];
    }
    
// ====================== Method call for fetching posts ======================
    
    [self getTheAppNetPostTimelineData];
}


- (void)refresh:(UIRefreshControl *)refreshControl
{
    self.refreshControl.tag =111;
    [self getTheAppNetPostTimelineData];
}

-(void)getTheAppNetPostTimelineData{
    
    NSString *string = [NSString stringWithFormat:@"%@", BASE_URL];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if(self.refreshControl.tag == 111){
        [self.spinner setHidden:YES];
    }else{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    }
    
// ============ Using AFNetworking library feature to contact sever and fetch posts =============
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dataArray = (NSArray *)responseObject;
        NSLog(@"success");
        if (dataArray)
        {
            [self.tmpPostDataArray addObjectsFromArray:[dataArray valueForKey:@"data"]];

            
// ================ Sorting the posts in decending order and populating tableView ================
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            self.postDataArray = [self.tmpPostDataArray sortedArrayUsingDescriptors:sortDescriptors];
            
            [self.spinner stopAnimating];
            [self.postTableView reloadData];
            
            if(self.refreshControl){
                [self.refreshControl endRefreshing];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:app_name message:no_data_msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.spinner stopAnimating];
        [self.refreshControl endRefreshing];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data" message:[error localizedDescription]delegate:nil
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }];
    [operation start];
}

#pragma mark - Table view data source methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.postDataArray valueForKey:@"data"]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"Cell";
    UIImageView *postImageView;
    UILabel *postNameLabel;
    UILabel *postDetailLabel;
    [self.postTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; // reuse of tableViewCell
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
        
// ================Use of asyncImageView to fetch the images asycnhornously ======================

        postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 45.0f, 45.0f)];
        [postImageView setBackgroundColor:[UIColor clearColor]];
        postImageView.layer.cornerRadius = CORNER_RADIUS;
        postImageView.layer.masksToBounds = YES;
        postImageView.layer.borderWidth = 2;
        postImageView.tag = 011;
        postImageView.layer.borderColor = [UIColor whiteColor].CGColor;
         [cell.contentView addSubview:postImageView];
        
// ==================== setting the properties for post name textField ========================
        
        postNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 5.0f, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN +5), 25.0f)];
        [postNameLabel setBackgroundColor:[UIColor clearColor]];
        [postNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [postNameLabel setTag:1];
        [cell.contentView addSubview:postNameLabel];
        
// ==================== setting the properties for post detail textField ========================
        
        postDetailLabel = [[UILabel alloc]init];
        [postDetailLabel setBackgroundColor:[UIColor clearColor]];
        [postDetailLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [postDetailLabel setTextColor:[UIColor lightGrayColor]];
        [postDetailLabel setTag:2];
        [postDetailLabel setNumberOfLines:0];
        [cell.contentView addSubview:postDetailLabel];
    }
    
// ================= Inserting the post info into textFields and imageView ========================
    
    if(!postImageView){
        postImageView = (UIImageView *) [cell viewWithTag:011];
    }
    NSString *imageUrl = [[[[self.postDataArray objectAtIndex:indexPath.row]valueForKey:@"user"]valueForKey:@"avatar_image"]valueForKey:@"url"];
    [postImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"navbar.png"]];

    if(!postNameLabel)
        postNameLabel = (UILabel *)[cell viewWithTag:1];
    [postNameLabel setText:[[[self.postDataArray objectAtIndex:indexPath.row]valueForKey:@"user"]valueForKey:@"name"]];
    
    NSString *text = [[self.postDataArray objectAtIndex:indexPath.row]valueForKey:@"text"];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN), 20000.0f);
    CGSize size = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size;
    
    if (!postDetailLabel)
        postDetailLabel = (UILabel*)[cell viewWithTag:2];
    [postDetailLabel setText:text];
    [postDetailLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, 20, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN+5), MAX(size.height, 44.0f))];
    
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - Table view delegate method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

// ============== To make the dynamic height of UITableViewCell according to text ===============
    
    NSString *text = [[self.postDataArray objectAtIndex:indexPath.row]valueForKey:@"text"];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN), 20000.0f);
    CGSize size = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil].size;
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN-30);
}


// this method controls the spinner.
-(void)threadStartAnimating:(id)data
{
    [self.spinner startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
