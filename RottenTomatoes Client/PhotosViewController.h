//
//  PhotosViewController.h
//  RottenTomatoes Client
//
//  Created by Rafi Romero on 2/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UINavigationController* nav;
@end
