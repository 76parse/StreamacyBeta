//
//  TrackObject.h
//  StreamacyWireFrame
//
//  Created by Andrew Friedman on 3/13/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLIENT_ID @"40da707152150e8696da429111e3af39"

//Track Object constants
extern NSString *const TrackStreamURL;
extern NSString *const TrackArtworkURL;
extern NSString *const TrackUsernameTitle;
extern NSString *const TrackDuration;
extern NSString *const TrackTitle;
extern NSString *const TrackUser;


//Saving Playlists constants
extern NSString *const ArrayOfSavedLists;
extern NSString *const SavedListName;
extern NSString *const SavedListTracks;

extern NSString *const kNoArwork;

@interface TrackObject : NSObject

@property  NSString *streamingURL;
@property  NSString *artworkURL;
@property  NSDictionary *user;
@property  NSString *username;
@property  NSString *trackTitle;
@property  double duration;
@property NSDictionary *trackData;

-(id)initWithData:(NSDictionary *)data;
-(NSDictionary *)trackObjectAsDictionary:(TrackObject *)trackObject;
@end

