//
//  SASearchUserViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASearchUserViewController.h"
#import "SASearchPlaylistCollectionViewCell.h"
#import "SoundCloudAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SASearchPlaylistViewController.h"
#import "SAActionMenuViewController.h"
#import "SAActionSheetAnimator.h"

@interface SASearchUserViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *tracks;
@property (strong, nonatomic) NSArray *playlists;
@end

@implementation SASearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tracks = [[NSMutableArray alloc]init];
    self.playlists = [[NSMutableArray alloc]init];
    
    NSString *avatarString = self.user[@"avatar_url"];
    NSURL *avatarURL = [NSURL URLWithString:avatarString];
    [self.avatarImageView sd_setImageWithURL:avatarURL];
    
    NSString *username = self.user[@"username"];
    self.usernameLabel.text = username;
    
    self.navigationItem.title = username;
    
    NSNumber *followersCount = self.user[@"followers_count"];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:followersCount];
    self.followerCountLabel.text = formatted;
    
    NSString *userID = self.user[@"id"];
    [SoundCloudAPI getPlaylistsWithUser:userID allPlaylists:YES withCompletion:^(NSMutableArray *playlists) {
        self.playlists = playlists;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:
         UITableViewRowAnimationFade];
    }];
    
    [SoundCloudAPI getTracksWithSearch:nil userID:userID withCompletion:^(NSMutableArray *tracks) {
        self.tracks = tracks;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:
         UITableViewRowAnimationFade];
    }];

}

#pragma mark - Table View Delegate/Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return self.tracks.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return 181;
    else
        return 70;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return @"Playlists";
    else
        return @"Songs";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"Playlists";
        SASearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        return cell;
    }
    else{
        static NSString *identifier = @"Songs";
        SASearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.delegate = self;
        cell.searchDelegate = self;
        NSDictionary *track = self.tracks[indexPath.row];
        [cell setDisplayForTrack:track];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(SASearchTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.playlistCollectionView.dataSource = self;
    cell.playlistCollectionView.delegate = self;
    cell.playlistCollectionView.tag = 0;
    [cell.playlistCollectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.playlists.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Playlists";
    SASearchPlaylistCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *playlist = self.playlists[indexPath.row];
    [cell setDisplayForPlaylist:playlist];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *playlist = self.playlists[indexPath.row];
    [self performSegueWithIdentifier:@"toPlaylistVC" sender:playlist];
}
#pragma mark - MGSwipableTableCell Delegate

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell canSwipe:(MGSwipeDirection)direction
{
    return YES;
}

-(NSArray *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    [SASwipeButtonSettings setSwipeSettings:swipeSettings expansionSettings:expansionSettings];
    if (direction == MGSwipeDirectionLeftToRight) {
        expansionSettings.expansionColor = [SASwipeButtonSettings leftExpansionColor];
        return [SASwipeButtonSettings leftButtons];
    }
    else{
        expansionSettings.expansionColor = [SASwipeButtonSettings rightExpansionColor];
        return [SASwipeButtonSettings rightButtons];
    }
}

-(BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)cell];
    NSDictionary *selectedTrack = self.tracks[indexPath.row];
    TrackObject *track = [[TrackObject alloc]initWithData:selectedTrack];
    if (direction == MGSwipeDirectionLeftToRight) {
        [SASwipeButtonSettings performActionForLeftSwipeWithTrack:track];
    }
    else
    {
        [SASwipeButtonSettings performActionForRightSwipeWithTrack:track];
    }
    return YES;
}

#pragma mark - Search Cell Delegate

-(void)plusButtonPressedOnCell:(SASearchTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *track = self.tracks[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ActionMenu" bundle:nil];
    SAActionMenuViewController *actionMenuVC = (SAActionMenuViewController *)[storyboard instantiateInitialViewController];
    actionMenuVC.track = track;
    actionMenuVC.transitioningDelegate = self;
    actionMenuVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:actionMenuVC animated:YES completion:^{
        //animations
    }];
}

#pragma mark - Animated Transitioning Delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    SAActionSheetAnimator *animator = [SAActionSheetAnimator new];
    animator.presenting = YES;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    SAActionSheetAnimator *animator = [SAActionSheetAnimator new];
    return animator;
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPlaylistVC"]) {
        SASearchPlaylistViewController *playlistVC = segue.destinationViewController;
        playlistVC.playlist = sender;
    }
}

@end
