//
//  PlaylistParseAPI.m
//  Streamacy
//
//  Created by Andrew Friedman on 4/12/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "PlaylistParseAPI.h"

@implementation PlaylistParseAPI

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

+ (void)createPlaylistWithName:(NSString *)name withCompletion:(void(^)(BOOL success))completion
{
    PFUser *currentUser = [PFUser currentUser];
    PFObject *playlistObject = [PFObject objectWithClassName:@"Playlists"];
    [playlistObject setObject:[currentUser objectId] forKey:@"userId"];
    [playlistObject setObject:name forKey:@"playlistName"];
    [playlistObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error creating/saving playlist");
        }
        else{
            completion((BOOL )YES);
        }
    }];
    
}

//Saves a track to the selected playlist

+ (void)saveTrack:(NSDictionary *)track toPlaylist:(PFObject *)playlist withCompletion:(void(^)(BOOL success))completion
{

    [playlist addObject:track forKey:@"playlist"];
    [playlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error creating/saving playlist");
        }
        else{
            completion((BOOL)YES);
        }
    }];
}

+(void)deleteTrack:(NSDictionary *)track fromPlayList:(PFObject *)playlist
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


+ (NSMutableDictionary *)trackAsDictionary:(NSMutableDictionary *)data
{
    NSLog(@"%@", data);
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:data[TrackUser] forKey:TrackUser];
    [dictionary setObject:data[TrackStreamURL] forKey:TrackStreamURL];
    [dictionary setObject:data[TrackArtworkURL] forKey:TrackArtworkURL];
    [dictionary setObject:data[TrackUsernameTitle] forKey:TrackUsernameTitle];
    [dictionary setObject:data[TrackDuration] forKey:TrackDuration];
    [dictionary setObject:data[TrackPlaybackCount] forKey:TrackPlaybackCount];
    return dictionary;
}


@end
