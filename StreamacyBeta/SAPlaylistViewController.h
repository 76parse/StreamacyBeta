//
//  SAPlaylistViewController.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/22/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASearchTableViewCell.h"
#import "MGSwipeTableCell.h"
#import <Parse/Parse.h>

@interface SAPlaylistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SearchCellDelegate, MGSwipeTableCellDelegate, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) PFObject *playlist;
@end
