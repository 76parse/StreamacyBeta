//
//  SAActionMenuViewController.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAActionSaveViewController.h"

@interface SAActionMenuViewController : UIViewController <UIViewControllerTransitioningDelegate, SAActionSaveDelegate>
@property (strong, nonatomic) NSDictionary *track;
@end
