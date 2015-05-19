//
//  SoundCloudAPI.h
//  
//
//  Created by Andrew Friedman on 3/28/15.
//
//

#import <Foundation/Foundation.h>

extern NSString *const ClientID;

@interface SoundCloudAPI : NSObject
+ (void)getTracksWithSearch:(NSString *)search userID:(NSString *)userID withCompletion:(void(^)(NSMutableArray *tracks))completion;
+ (void)getUsersWithSearch:(NSString *)search withCompletion:(void(^)(NSMutableArray *users)) completion;
+(void)getPlaylistsWithUser:(NSString *)userId allPlaylists:(BOOL )all withCompletion:(void(^)(NSMutableArray *playlists))completion;
@end
