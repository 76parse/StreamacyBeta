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
#import "SAPlaylistViewController.h"

@interface SAPlaylistsViewController ()
- (IBAction)editButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)addButtonPressed:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *playlists;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButton;
@property (assign, nonatomic) BOOL editSelected;
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
        PFObject *playlist= self.playlists[indexPath.row];
        [self performSegueWithIdentifier:@"toPlaylistVC" sender:playlist];
    }
    else if (indexPath.section == 1)
    {
        UIAlertView *addPlaylistAlert = [[UIAlertView alloc]initWithTitle:@"Add Playlist" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        addPlaylistAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [addPlaylistAlert show];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //delete the cell and save the updated Parse Playlist
        PFObject *playlist = self.playlists[indexPath.row];
        [self.playlists removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self hideRightBarButtonItem:self.playlists.count];
        if (!self.playlists.count) {
            [self editButtonPressed:self.editButtonItem];
        }
        [playlist deleteInBackground];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return NO;
    else
        return self.tableView.isEditing;
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

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender
{
    [self hideLeftBarButtonItem:self.editSelected];
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

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertView *addPlaylistAlert = [[UIAlertView alloc]initWithTitle:@"Add Playlist" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    addPlaylistAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addPlaylistAlert show];
}

#pragma mark - Helpers

-(void)hideLeftBarButtonItem:(BOOL)hidden
{
    if (hidden) {
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor clearColor]];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
    else{
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

-(void)hideRightBarButtonItem:(BOOL)playlistCount
{
    if (playlistCount) {
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
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


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPlaylistVC"]) {
        SAPlaylistViewController *playlistVC = segue.destinationViewController;
        playlistVC.playlist = sender;
    }
}
@end
