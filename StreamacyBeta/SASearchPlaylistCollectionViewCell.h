//
//  SASearchPlaylistCollectionViewCell.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASearchPlaylistCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *playlistImageView;
@property (strong, nonatomic) IBOutlet UILabel *playlistNameLabel;
-(void)setDisplayForPlaylist:(NSDictionary *)playlist;
@end
