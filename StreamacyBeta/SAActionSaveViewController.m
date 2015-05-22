//
//  SAActionSaveViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/22/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SAActionSaveViewController.h"
#import "SAPlaylistsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PlaylistParseAPI.h"
#import "Helpers.h"

@interface SAActionSaveViewController ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *artImageView;
@property (strong, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIView *actionMenuView;
@property (strong, nonatomic) IBOutlet UILabel *playbackCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@property (strong, nonatomic) NSArray *playlists;

- (IBAction)cancelButtonPressed:(UIButton *)sender;
@end

@implementation SAActionSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.cancelButton.layer.borderColor = [UIColor colorWithRed:0.784 green:0.778 blue:0.801 alpha:1].CGColor;
    self.headerView.layer.borderColor = [UIColor colorWithRed:0.784 green:0.778 blue:0.801 alpha:1].CGColor;
    self.actionMenuView.layer.borderColor = [UIColor colorWithRed:0.784 green:0.778 blue:0.801 alpha:1].CGColor;
    
    [self setDisplayForHeaderWithTrack:self.track];
    
    PFUser *current = [PFUser currentUser];
    if (current) {
        [PlaylistParseAPI getPlaylistsForUser:current withCompletion:^(NSMutableArray *playlists) {
            self.playlists = playlists;
            [self.tableView reloadData];
        }];
    }

}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Table View Delegate/Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.playlists.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.playlists.count) {
        return @"Playlists";
    }
    else{
        return @"No playlists";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Playlists";
    SAPlaylistsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *playlist = self.playlists[indexPath.row];
    [cell setDisplayForPlaylist:playlist];
    return cell;
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
           [self dismissViewControllerAnimated:YES completion:^{
            //complete dismiss of view controller
           }];
}

#pragma mark - Helpers

-(void)setDisplayForHeaderWithTrack:(NSDictionary *)track
{
    //Populate the cell with the data recieved from the search.
    self.trackTitleLabel.text = track[@"title"];
    self.usernameLabel.text = track[@"user"][@"username"];
    int duration = [[track objectForKey:@"duration"]intValue];
    NSString *durationString = [Helpers timeFormatted:duration];
    self.durationLabel.text = durationString;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage * img = self.artImage;
        
        // Make a trivial (1x1) graphics context, and draw the image into it
        UIGraphicsBeginImageContext(CGSizeMake(1,1));
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [img CGImage]);
        UIGraphicsEndImageContext();
        
        // Now the image will have been loaded and decoded and is ready to rock for the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.artImageView setImage: img];
        });
    });
    
    NSNumber *playbackCount = track[@"playback_count"];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *playbackformatted = [formatter stringFromNumber:playbackCount];
    NSString *triangle = [NSString stringWithCString:"\u25BA" encoding:NSUTF8StringEncoding];
    self.playbackCountLabel.text = [NSString stringWithFormat:@"%@ %@", triangle, playbackformatted];
    
    
}
@end
