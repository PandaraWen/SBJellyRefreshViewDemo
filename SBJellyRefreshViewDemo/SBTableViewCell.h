//
//  SBTableViewCell.h
//  SBJellyRefreshViewDemo
//
//  Created by Pandara on 15/10/29.
//  Copyright © 2015年 Pandara. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SBCELL_ID @"sbcell"

@interface SBTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end
