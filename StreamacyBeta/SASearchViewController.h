//
//  SASearchViewController.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "SASearchTableViewCell.h"
#import "SAActionSheetAnimator.h"

@interface SASearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, MGSwipeTableCellDelegate, SearchCellDelegate, UIViewControllerTransitioningDelegate>

@end
