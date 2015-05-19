//
//  SASearchPlaylistCollectionViewCell.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASearchPlaylistCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SASearchPlaylistCollectionViewCell
-(void)setDisplayForPlaylist:(NSDictionary *)playlist
{
    self.playlistNameLabel.text = playlist[@"title"];
    
    NSString *urlString = playlist[@"artwork_url"];
    if (![urlString isEqual:[NSNull null]]) {
        NSURL *artURL = [NSURL URLWithString:playlist[@"artwork_url"]];
        [self.playlistImageView sd_setImageWithURL:artURL];
    }
    else
    {
        [self.playlistImageView setImage:[UIImage imageNamed:@"no-album-art.png"]];
    }
}
@end
