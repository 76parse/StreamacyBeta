//
//  SAActionSaveViewController.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/22/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SAActionSaveDelegate <NSObject>
@optional
-(void)dismissedchildViewController:(UIViewController *)viewController;
@end

@interface SAActionSaveViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id delegate;

@property (strong, nonatomic) NSDictionary *track;
@property (strong, nonatomic) UIImage *artImage;
@end
