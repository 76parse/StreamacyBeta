//
//  SAPlaylistViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/22/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SAPlaylistViewController.h"
#import "SASwipeButtonSettings.h"
#import "SAActionMenuViewController.h"
#import "SAActionSheetAnimator.h"

@interface SAPlaylistViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) NSMutableArray *tracks;
@property (assign, nonatomic) BOOL editSelected;
@end

@implementation SAPlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tracks = [[NSMutableArray alloc]init];
    
    self.tracks = self.playlist[@"playlist"];
    self.navigationItem.title = self.playlist[@"playlistName"];
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate/Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.tracks.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Songs";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Songs";
    SASearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *track = self.tracks[indexPath.row];
    cell.delegate = self;
    cell.searchDelegate = self;
    [cell setDisplayForTrack:track];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete the cell and save the updated Parse Playlist
        [self.tracks removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.playlist saveInBackground];
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        [cell.contentView setNeedsUpdateConstraints];
    }
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

#pragma mark - Custom Buttons

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender
{
    if (self.editSelected) {
        sender.title = @"Edit";
        [self.tableView setEditing:NO animated:YES];
        self.editSelected = NO;
    }
    else{
        sender.title = @"Done";
        [self.tableView setEditing:YES animated:YES];
        self.editSelected = YES;
    }

}
@end
