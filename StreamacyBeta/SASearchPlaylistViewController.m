//
//  SASearchPlaylistViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASearchPlaylistViewController.h"
#import "SAActionSheetAnimator.h"
#import "SAActionMenuViewController.h"

@interface SASearchPlaylistViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tracks;
@end

@implementation SASearchPlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tracks = [[NSMutableArray alloc]init];
    
    
    NSDictionary *playlist = self.playlist;
    
    self.navigationItem.title = playlist[@"title"];
    
    NSArray *playlistTracks = playlist[@"tracks"];
    self.tracks = playlistTracks;
    
}

#pragma mark - Table View Delegate/Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tracks.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Songs";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Songs";
    SASearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.delegate = self;
    cell.searchDelegate = self;
    NSDictionary *track = self.tracks[indexPath.row];
    [cell setDisplayForTrack:track];
    return cell;
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


@end
