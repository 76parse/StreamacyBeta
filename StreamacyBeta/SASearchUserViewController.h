//
//  SASearchUserViewController.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASwipeButtonSettings.h"
#import "MGSwipeTableCell.h"
#import "SASearchTableViewCell.h"

@interface SASearchUserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MGSwipeTableCellDelegate, UIViewControllerTransitioningDelegate, SearchCellDelegate>
@property (strong, nonatomic) NSDictionary *user;
@end
