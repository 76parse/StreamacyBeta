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
+(void)getPlaylistsForUser:(PFUser *)user withCompletion:(void(^)(NSMutableArray *playlists))completion;
+(void)createPlaylistWithName:(NSString *)name withCompletion:(void(^)(BOOL success))completion;
+(void)saveTrack:(TrackObject *)track toPlaylist:(PFObject *)playlist withCompletion:(void(^)(BOOL success))completion;
+(void)deleteTrack:(TrackObject *)track fromPlayList:(PFObject *)playlist;
+(void)deletePlaylist:(PFObject *)playlist;
@end
