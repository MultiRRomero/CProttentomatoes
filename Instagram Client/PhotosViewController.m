//
//  PhotosViewController.m
//  Instagram Client
//
//  Created by Rafi Romero on 2/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "PhotosViewController.h"
#import "ImageTableViewCell.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface PhotosViewController ()
@property (weak, nonatomic) IBOutlet UITableView *uiTableView;
@property (nonatomic, strong) NSDictionary* instagramMediaDictionary;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.uiTableView.dataSource = self;
    self.uiTableView.delegate = self;
    
    UINib* cellNib = [UINib nibWithNibName:@"ImageTableViewCell" bundle:nil];
    [self.uiTableView registerNib:cellNib forCellReuseIdentifier:@"ImageTableViewCell"];
    
    self.uiTableView.rowHeight = 380;

    self.instagramMediaDictionary = @{@"data":@[]};
    [self makeURLRequest];
}

- (void)makeURLRequest {
    NSURL *url = [NSURL URLWithString:@"https://api.instagram.com/v1/media/popular?client_id=2cf1eb8914d64a1a8faaa60d9001e958"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         
         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSLog(@"response: %@", responseDictionary);
         
         self.instagramMediaDictionary = responseDictionary;
         [self.uiTableView reloadData];
     }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSArray* data = self.instagramMediaDictionary[@"data"];
    return [data count];
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* url = self.instagramMediaDictionary[@"data"][indexPath.row][@"images"][@"standard_resolution"][@"url"];
    
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell" forIndexPath:indexPath];
    [cell.uiImageView setImageWithURL:[NSURL URLWithString:url]];
    
    return cell;
    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = [NSString stringWithFormat:@"This is row %ld", (long)indexPath.row];
//    return cell;
//    
//    ImageTableViewCell* itvc = [[ImageTableViewCell alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
