//
//  ImageTableViewCell.h
//  RottenTomatoes Client
//
//  Created by Rafi Romero on 2/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *uiImageView;
@property (weak, nonatomic) IBOutlet UILabel *uiTitle;
@property (weak, nonatomic) IBOutlet UITextView *uiDescription;
@end
