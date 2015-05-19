//
//  SASearchViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASearchViewController.h"
#import "SASearchTableViewCell.h"
#import "SASearchCollectionViewCell.h"
#import "SoundCloudAPI.h"

@interface SASearchViewController ()
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tracks;
@property (strong, nonatomic) NSMutableArray *users;
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
    self.tableView.hidden = NO;
    //Get the tracks and users and reload the table view
    NSString *userInput = searchBar.text;
    [SoundCloudAPI getUsersWithSearch:userInput withCompletion:^(NSMutableArray *users) {
        self.users = [users mutableCopy];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:
         UITableViewRowAnimationFade];
    }];
    [SoundCloudAPI getTracksWithSearch:userInput userID:nil withCompletion:^(NSMutableArray *tracks) {
        self.tracks = tracks;
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
    return [self.users count];
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



@end
