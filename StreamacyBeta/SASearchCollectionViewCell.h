//
//  SASearchCollectionViewCell.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASearchCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;

-(void)setDisplayForUser:(NSDictionary *)user;
@end
