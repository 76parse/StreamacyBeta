//
//  SAPlaylistsTableViewCell.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/21/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SAPlaylistsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SAPlaylistsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDisplayForPlaylist:(NSDictionary *)playlist;
{
    NSMutableArray *tracks = playlist[@"playlist"];
    self.trackCountLabel.text = [NSString stringWithFormat:@"%lu tracks", (unsigned long)tracks.count];
    if (tracks.count) {
        NSString *artworkString = playlist[@"playlist"][0][@"artwork_url"];
        NSURL *artworkURL = [NSURL URLWithString:artworkString];
        [self.artImageView sd_setImageWithURL:artworkURL];
    }
    else
    {
        [self.artImageView setImage:[UIImage imageNamed:@"no-album-art.png"]];
    }
    self.playlistNameLabel.text = playlist[@"playlistName"];

}

@end
