//
//  PlaylistParseAPI.h
//  Streamacy
//
//  Created by Andrew Friedman on 4/12/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "TrackObject.h"

@interface PlaylistParseAPI : NSObject

@property (assign, nonatomic) BOOL playlistNeedsReload;
@property (strong, nonatomic) NSMutableArray *playlistCache;

@property (strong, nonatomic) PFQuery *playlistQuery;

+(void)getPlaylistsForUser:(PFUser *)user withCompletion:(void(^)(NSMutableArray *playlists))completion;
+(void)createPlaylistWithName:(NSString *)name withCompletion:(void(^)(BOOL success))completion;
+(void)saveTrack:(NSDictionary *)track toPlaylist:(PFObject *)playlist withCompletion:(void(^)(BOOL success))completion;
+(void)deleteTrack:(NSDictionary *)track fromPlayList:(PFObject *)playlist;
+(void)deletePlaylist:(PFObject *)playlist;
@end
