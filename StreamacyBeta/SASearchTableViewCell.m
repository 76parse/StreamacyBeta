//
//  SASearchTableViewCell.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASearchTableViewCell.h"
#import "Helpers.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SASearchTableViewCell

-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.tag = index;
    [self.collectionView reloadData];
}

-(void)setDisplayForTrack:(NSDictionary *)track
{
    //Populate the cell with the data recieved from the search.
    self.trackTitleLabel.text = track[@"title"];
    self.userLabel.text = track[@"user"][@"username"];
    //Format the tracks duration into a string and set the label.
    int duration = [[track objectForKey:@"duration"]intValue];
    NSString *durationString = [Helpers timeFormatted:duration];
    self.durationLabel.text = durationString;
    
    NSString *urlString = track[@"artwork_url"];
    if (![urlString isEqual:[NSNull null]]) {
        NSURL *artURL = [NSURL URLWithString:track[@"artwork_url"]];
        [self.coverArtImageView sd_setImageWithURL:artURL];
    }
    else
    {
        [self.coverArtImageView setImage:[UIImage imageNamed:@"no-album-art.png"]];
    }

}


- (IBAction)plusButtonPressed:(UIButton *)sender {
}
@end
