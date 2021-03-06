//
//  SASearchViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASearchViewController.h"
#import "SASearchCollectionViewCell.h"
#import "SoundCloudAPI.h"
#import "SASearchUserViewController.h"
#import "SASwipeButtonSettings.h"
#import "TrackObject.h"
#import "RBStoryboardLink.h"
#import "SAActionMenuViewController.h"
#import "Helpers.h"

@interface SASearchViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tracks;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) UIImageView *expandedImageView;
@property (nonatomic, assign) BOOL imageIsExpanded;
@property (nonatomic) CGRect imagePoint;
@end

@implementation SASearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    
    self.searchBar.delegate = self;
    
    self.tracks = [[NSMutableArray alloc]init];
    self.users = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - Search Bar Delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top) animated:YES];
    //Get the tracks and users and reload the table view
    NSString *userInput = searchBar.text;
    [SoundCloudAPI getUsersWithSearch:userInput withCompletion:^(NSMutableArray *users) {
        self.users = [users mutableCopy];
        self.tableView.hidden = NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:
         UITableViewRowAnimationFade];
    }];
    [SoundCloudAPI getTracksWithSearch:userInput userID:nil withCompletion:^(NSMutableArray *tracks) {
        self.tracks = tracks;
        self.tableView.hidden = NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:
         UITableViewRowAnimationFade];
    }];
}


#pragma mark - Table View Delegate/Data Source

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

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
        return @"Users";
    else
        return @"Songs";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"Users";
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
    [cell setCollectionViewDataSourceDelegate:self index:0];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.users.count;
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


#pragma mark - CollectionView Delegate/DataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"User";
    SASearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *user = self.users[indexPath.row];
    [cell setDisplayForUser:user];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *user = self.users[indexPath.row];
    [self performSegueWithIdentifier:@"toUserVC" sender:user];
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
    if ([segue.identifier isEqualToString:@"toUserVC"]) {
        SASearchUserViewController  *userVC = segue.destinationViewController;
        userVC.user = sender;
    }
}


@end
