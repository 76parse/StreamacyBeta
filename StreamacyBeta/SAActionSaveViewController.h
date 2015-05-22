//
//  SAActionSaveViewController.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/22/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAActionSaveViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSDictionary *track;
@property (strong, nonatomic) UIImage *artImage;
@end
