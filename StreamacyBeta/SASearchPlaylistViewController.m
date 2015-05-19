//
//  SASearchPlaylistViewController.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASearchPlaylistViewController.h"
#import "SASearchTableViewCell.h"

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
    NSDictionary *track = self.tracks[indexPath.row];
    [cell setDisplayForTrack:track];
    return cell;
}

@end
