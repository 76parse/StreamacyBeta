//
//  SAPlaylistsViewController.m
//  
//
//  Created by Andrew Friedman on 5/19/15.
//
//

#import "SAPlaylistsViewController.h"
#import "SAPlaylistsTableViewCell.h"
#import "PlaylistParseAPI.h"

@interface SAPlaylistsViewController ()
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addButtonPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *playlists;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButton;
@end

@implementation SAPlaylistsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.playlists = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self hideLeftBarButtonItem:YES];
    [self getPlaylistsForCurrentUser];
}


#pragma mark - Table View Delegate/ Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return self.playlists.count;
    else
        return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.playlists.count == 0) {
            return @"";
        }
        else
            return @"Playlists";
    }
    else
        return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"Playlists";
        SAPlaylistsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        NSDictionary *playlist = self.playlists[indexPath.row];
        [cell setDisplayForPlaylist:playlist];
        return cell;
    }
    else{
        static NSString *identifier = @"AddPlaylist";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //push to the playlists view controller.
    }
    else if (indexPath.section == 1)
    {
        UIAlertView *addPlaylistAlert = [[UIAlertView alloc]initWithTitle:@"Add Playlist" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        addPlaylistAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [addPlaylistAlert show];
    }
}

#pragma mark - Alert View Delegate

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    return ([[[alertView textFieldAtIndex:0] text] length]>0)?YES:NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        NSString *playlistName = [alertView textFieldAtIndex:0].text;
        [PlaylistParseAPI createPlaylistWithName:playlistName withCompletion:^(BOOL success)
         {
             if (success) {
                 [self getPlaylistsForCurrentUser];
             }
         }];
    }
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
}

#pragma mark - Helpers

-(void)hideLeftBarButtonItem:(BOOL)hidden
{
    if (hidden) {
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor clearColor]];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    else{
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

-(void)hideRightBarButtonItem:(BOOL)playlistCount
{
    if (playlistCount) {
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void)getPlaylistsForCurrentUser
{
    PFUser *current = [PFUser currentUser];
    if (current) {
        [PlaylistParseAPI getPlaylistsForUser:current withCompletion:^(NSMutableArray *playlists) {
            [self hideRightBarButtonItem:playlists.count];
            self.playlists = playlists;
            [self.tableView reloadData];
        }];
    }
}
@end
