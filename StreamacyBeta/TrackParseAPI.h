//
//  TrackParseAPI.h
//  Streamacy
//
//  Created by Andrew Friedman on 3/28/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "TrackObject.h"

@interface TrackParseAPI : NSObject

+(void)getPlaylistsForUser:(PFUser *)user withCompletion:(void(^)(NSMutableArray *playlists))completion;
+(void)createPlaylistWithName:(NSString *)name andSaveTrack:(TrackObject *)track;
+(void)saveTrack:(TrackObject *)track toPlaylist:(PFObject *)playlist;
+(void)deleteTrack:(TrackObject *)track fromPlayList:(PFObject *)playlist;
+(void)deletePlaylist:(PFObject *)playlist;
@end
