//
//  PhotosViewController.m
//  RottenTomatoes Client
//
//  Created by Rafi Romero on 2/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "PhotosViewController.h"
#import "ImageTableViewCell.h"
#import "MovieDetailsViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface PhotosViewController ()
@property (weak, nonatomic) IBOutlet UITableView *uiTableView;
@property (nonatomic, strong) NSDictionary* rottenTomatoesDictionary;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property BOOL isNetworkError;
@end

@implementation PhotosViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Movies";
    // Do any additional setup after loading the view from its nib.
    
    self.uiTableView.dataSource = self;
    self.uiTableView.delegate = self;
    
    UINib* cellNib = [UINib nibWithNibName:@"ImageTableViewCell" bundle:nil];
    [self.uiTableView registerNib:cellNib forCellReuseIdentifier:@"ImageTableViewCell"];
    
    self.uiTableView.rowHeight = 132;
    self.uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.uiTableView.backgroundColor = [UIColor blackColor];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.uiTableView insertSubview:self.refreshControl atIndex:0];

    self.rottenTomatoesDictionary = @{@"movies":@[]};
        
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self makeURLRequest];
    });

}

- (void)makeURLRequest {
    NSString *urlStr = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=3pbd23xkdwawk587eva9ubkr&limit=6";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         self.isNetworkError = (data == nil);
         
         self.rottenTomatoesDictionary = self.isNetworkError
            ? @{@"movies":@[]}
            : [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         [self.uiTableView reloadData];
     }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSArray* data = self.rottenTomatoesDictionary[@"movies"];
    return [data count]; // at least 4 rows
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.isNetworkError
        ? [[[NSBundle mainBundle] loadNibNamed:@"NetworkErrorView"
                                         owner:self
                                       options:nil] firstObject]
        : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.isNetworkError ? 48 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell" forIndexPath:indexPath];

    NSDictionary* dict = self.rottenTomatoesDictionary[@"movies"][indexPath.row];
    cell.uiTitle.text = dict[@"title"];
    cell.uiDescription.text = dict[@"synopsis"];
    cell.uiDescription.textColor = [UIColor whiteColor];
    
    NSString* urlStr = dict[@"posters"][@"original"];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    NSURL* url = [NSURL URLWithString:urlStr];
    
    [cell.uiImageView setImageWithURLRequest:[NSMutableURLRequest requestWithURL:url]
                            placeholderImage:nil
                                     success:
      ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
          if (!request) {
              [cell.uiImageView setImage:image];
          } else {
              [UIView transitionWithView:cell.uiImageView
                                duration:1.0
                                 options:UIViewAnimationOptionTransitionCrossDissolve
                              animations:^{ [cell.uiImageView setImage:image]; }
                              completion:nil];
          }
      } failure:nil];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailsViewController *details = [[MovieDetailsViewController alloc] init];
    
    NSDictionary* dict = self.rottenTomatoesDictionary[@"movies"][indexPath.row];
    details.synopsis = dict[@"synopsis"];
    details.imageUrl = [dict[@"posters"][@"original"] stringByReplacingOccurrencesOfString:@"tmb"
                                                                                withString:@"ori"];
    
    [self.nav pushViewController:details animated:YES];
}

- (void)onRefresh {
    self.isNetworkError = nil;
    self.rottenTomatoesDictionary =  @{@"movies":@[]};
    [self.uiTableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self makeURLRequest];
    });
}

@end
