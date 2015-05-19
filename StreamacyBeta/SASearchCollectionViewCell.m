//
//  SASearchCollectionViewCell.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASearchCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SASearchCollectionViewCell
-(void)setDisplayForUser:(NSDictionary *)user
{
    self.userLabel.text = user[@"username"];
    
    NSString *urlString = user[@"avatar_url"];
    if (![urlString isEqual:[NSNull null]]) {
        NSURL *artURL = [NSURL URLWithString:user[@"avatar_url"]];
        [self.avatarImageView sd_setImageWithURL:artURL];
    }
    else
    {
        [self.avatarImageView setImage:[UIImage imageNamed:@"no-album-art.png"]];
    }
}
@end
