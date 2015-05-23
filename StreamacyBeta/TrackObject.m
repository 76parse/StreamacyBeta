//
//  TrackObject.m
//  StreamacyWireFrame
//
//  Created by Andrew Friedman on 3/13/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "TrackObject.h"
#import <Parse/Parse.h>

//Track Object constants
NSString *const TrackStreamURL  = @"stream_url";
NSString *const TrackArtworkURL = @"artwork_url";
NSString *const TrackUsernameTitle = @"username";
NSString *const TrackDuration = @"duration";
NSString *const TrackTitle = @"title";
NSString *const TrackUser = @"user";
NSString *const TrackAvatarURL = @"avatar_url";
NSString *const TrackPermalinkURL = @"permalink_url";
NSString *const TrackPlaybackCount = @"playback_count";


//Saving Playlists constants
NSString *const ArrayOfSavedLists = @"SavedListsArray";
NSString *const SavedListName = @"SavedListName";
NSString *const SavedListTracks = @"SavedListTracks" ;

NSString *const kNoArwork = @"no_artwork";


@implementation TrackObject

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        NSLog(@"%@", data);
        self.trackData = [self dataAsDictionary:data];
        NSLog(@"%@", self.trackData);
    }
    return self;
}

- (NSDictionary *)dataAsDictionary:(NSDictionary *)data
{
    
    NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:
                                data[TrackUser], TrackUser,
                                data[TrackStreamURL], TrackStreamURL,
                                data[TrackArtworkURL], TrackArtworkURL,
                                data[TrackUsernameTitle], TrackUsernameTitle,
                                data[TrackDuration], TrackDuration,
                                data[TrackPlaybackCount], TrackPlaybackCount,
                                nil];
    
    return dictionary;
}

@end
