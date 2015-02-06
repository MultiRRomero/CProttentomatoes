//
//  MovieDetailsViewController.m
//  RottenTomatoes Client
//
//  Created by Rafi Romero on 2/10/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "MovieDetailsViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView2;
@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView2.text = self.synopsis;
    self.textView2.font = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
    self.textView2.textColor = [UIColor whiteColor];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:self.imageUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end