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

//Saving Playlists constants
NSString *const ArrayOfSavedLists = @"SavedListsArray";
NSString *const SavedListName = @"SavedListName";
NSString *const SavedListTracks = @"SavedListTracks" ;

NSString *const kNoArwork = @"no_artwork";


@implementation TrackObject

- (id)init
{
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    NSString *streamString = data[TrackStreamURL];
    //Check if the track being created already has the client ID, if not add it to the string. 
    if ([streamString containsString:CLIENT_ID]) {
        self.streamingURL = streamString;
    }
    else{
        NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@", data[TrackStreamURL],CLIENT_ID];
        self.streamingURL = urlString;
    }
    
    NSString *artworkString = data[TrackArtworkURL];
    if (![artworkString isEqual:[NSNull null]])
    {
        self.artworkURL = data[TrackArtworkURL];
    }
    else
    {
        self.artworkURL = kNoArwork;
    }

    self.trackTitle = data[TrackTitle];
    self.user = data[TrackUser];
    self.duration = [data[TrackDuration]doubleValue];
    self.trackData = [self trackObjectAsDictionary:self];
    return self;
}

- (NSDictionary *)trackObjectAsDictionary:(TrackObject *)track
{
    NSDictionary *dictonary = @{TrackUser: track.user, TrackStreamURL: track.streamingURL, TrackArtworkURL: track.artworkURL, TrackTitle: track.trackTitle, TrackDuration: @(track.duration)};
    
    return dictonary;
}

@end
