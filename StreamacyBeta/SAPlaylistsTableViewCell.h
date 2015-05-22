//
//  SAPlaylistsTableViewCell.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/21/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAPlaylistsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *artImageView;
@property (strong, nonatomic) IBOutlet UILabel *playlistNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *trackCountLabel;

-(void)setDisplayForPlaylist:(NSDictionary *)playlist;
@end
