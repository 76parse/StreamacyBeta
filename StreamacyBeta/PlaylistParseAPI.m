//
//  PlaylistParseAPI.m
//  Streamacy
//
//  Created by Andrew Friedman on 4/12/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "PlaylistParseAPI.h"
#import "EGOCache.h"

@implementation PlaylistParseAPI
@synthesize playlistCache = _playlistCache;

//Gets the playlists from the desired user
+(void)getPlaylistsForUser:(PFUser *)user withCompletion:(void(^)(NSMutableArray *playlists))completion
{
    PFQuery *userQuery = [PFQuery queryWithClassName:@"Playlists"];
    [userQuery whereKey:@"userId" equalTo:[user objectId]];
    [userQuery orderByDescending:@"createdAt"];
    userQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            NSMutableArray *playlists = [[NSMutableArray alloc]init];
            playlists = [objects mutableCopy];
                completion(playlists);
            }
    }];
}

+(void)clearPlaylistCache;
{
    PFUser *current = [PFUser currentUser];
    PFQuery *playlistQuery = [PFQuery queryWithClassName:@"Playlists"];
    [playlistQuery whereKey:@"userId" equalTo:[current objectId]];
    [playlistQuery orderByDescending:@"createdAt"];
    [playlistQuery clearCachedResult];
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
            [self clearPlaylistCache];
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
            [self clearPlaylistCache];
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
        else{
            [self clearPlaylistCache];
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
        else{
            [self clearPlaylistCache];
        }
    }];
}

@end
