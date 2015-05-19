//
//  SASearchPlaylistViewController.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASwipeButtonSettings.h"
#import "MGSwipeTableCell.h"

@interface SASearchPlaylistViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,MGSwipeTableCellDelegate>
@property (strong, nonatomic) NSDictionary *playlist;
@end
