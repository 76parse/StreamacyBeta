//
//  SASearchTableViewCell.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@protocol SearchCellDelegate <NSObject>
@optional
-(void)plusButtonPressedOnCell:(UITableViewCell *)cell;
@end

@interface SASearchTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) id searchDelegate;

@property (strong, nonatomic) IBOutlet UIImageView *coverArtImageView;
@property (strong, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
-(void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate index:(NSInteger)index;
@property (strong, nonatomic) IBOutlet UICollectionView *playlistCollectionView;

-(void)setDisplayForTrack:(NSDictionary *)track;

- (IBAction)plusButtonPressed:(UIButton *)sender;
@end
