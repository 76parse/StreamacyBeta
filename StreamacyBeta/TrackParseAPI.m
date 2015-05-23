//
//  TrackParseAPI.m
//  Streamacy
//
//  Created by Andrew Friedman on 3/28/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "TrackParseAPI.h"

@implementation TrackParseAPI

//Gets the playlists from the desired user

+(void)getPlaylistsForUser:(PFUser *)user withCompletion:(void(^)(NSMutableArray *playlists))completion
{
    PFQuery *userQuery = [PFQuery queryWithClassName:@"Playlists"];
    [userQuery whereKey:@"userId" equalTo:[user objectId]];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
        completion((NSMutableArray *)objects);
        }
    }];
}


//Method creates a playlist and adds the first track to it

+ (void)createPlaylistWithName:(NSString *)name andSaveTrack:(TrackObject *)track
{
    PFUser *currentUser = [PFUser currentUser];
    PFObject *playlistObject = [PFObject objectWithClassName:@"Playlists"];
    [playlistObject addObject:track forKey:@"playlist"];
    [playlistObject setObject:[currentUser objectId] forKey:@"userId"];
    [playlistObject setObject:name forKey:@"playlistName"];
    
    [playlistObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error creating/saving playlist");
        }
    }];
    
}

//Saves a track to the selected playlist

+ (void)saveTrack:(TrackObject *)track toPlaylist:(PFObject *)playlist
{
    [playlist addObject:track.trackData forKey:@"playlist"];
    [playlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error creating/saving playlist");
        }
    }];
}

+(void)deleteTrack:(TrackObject *)track fromPlayList:(PFObject *)playlist
{
    NSMutableArray *tracks = [playlist objectForKey:@"playlist"];
    [tracks removeObjectIdenticalTo:track];
    [playlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error deleting track from playlist");
        }
    }];
}

+(void)deletePlaylist:(PFObject *)playlist
{
    [playlist deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
    }];
}


@end
