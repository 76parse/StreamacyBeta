//
//  SoundCloudAPI.m
//  
//
//  Created by Andrew Friedman on 3/28/15.
//
//

#import "SoundCloudAPI.h"
#import <SCAPI.h>

NSString *const ClientID = @"40da707152150e8696da429111e3af39";

@implementation SoundCloudAPI

+ (void)getTracksWithSearch:(NSString *)search userID:(NSString *)userID withCompletion:(void(^)(NSMutableArray *tracks))completion
{
    NSString *resource;
    if (userID){
     resource = [NSString stringWithFormat:@"https://api.soundcloud.com/users/%@/tracks/?client_id=%@", userID, ClientID];
    }
    else{
    NSString *appendedInput = [search stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    resource = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks?client_id=%@&q=%@&format=json",ClientID, appendedInput];
    }
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resource]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSError *jsonError;
         NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:0
                                              error:&jsonError];
         
         if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]])
         {
             NSMutableArray *responseArray = [jsonResponse mutableCopy];
             NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
             NSUInteger currentIndex = 0;
             for (NSDictionary *track in responseArray) {
                 if ([track objectForKey:@"streamable"] == [NSNumber numberWithBool:false]) {
                     [indexesToDelete addIndex:currentIndex];
                 }
                 currentIndex++;
             }
             [responseArray removeObjectsAtIndexes:indexesToDelete];
             completion((NSMutableArray *) responseArray);
         }
     }];
}

+ (void)getUsersWithSearch:(NSString *)search withCompletion:(void(^)(NSMutableArray *users)) completion
{
    NSString *userInput = [search stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *userURL = [NSString stringWithFormat:@"https://api.soundcloud.com/users/?client_id=%@&q=%@&format=json",ClientID, userInput];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:userURL]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSError *jsonError;
         NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:0
                                              error:&jsonError];
         if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]])
         {
             NSArray *responseArray = (NSArray *)jsonResponse;
             if (responseArray.count > 3) {
                 NSMutableArray *subArray = [[responseArray subarrayWithRange:NSMakeRange(0, 3)]mutableCopy];
                 completion((NSMutableArray *) subArray);
             }
             else
             {
                 completion((NSMutableArray *) responseArray);
             }
             
        }
     }];

}


+(void)getPlaylistsWithUser:(NSString *)userId allPlaylists:(BOOL )all withCompletion:(void(^)(NSMutableArray *playlists))completion
{
    NSString *resource = [NSString stringWithFormat:@"https://api.soundcloud.com/users/%@/playlists/?client_id=%@", userId, ClientID];
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resource]
             usingParameters:nil
                 withAccount:nil
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSError *jsonError;
         NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                              JSONObjectWithData:data
                                              options:0
                                              error:&jsonError];
         
         if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]])
         {
             NSMutableArray *responseArray = [jsonResponse mutableCopy];
             NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
             NSUInteger currentIndex = 0;
             for (NSDictionary *track in responseArray) {
                 if ([track objectForKey:@"streamable"] == [NSNumber numberWithBool:false]) {
                     [indexesToDelete addIndex:currentIndex];
                 }
                 currentIndex++;
             }
             [responseArray removeObjectsAtIndexes:indexesToDelete];
             
             if (all) {
                 completion((NSMutableArray *)responseArray);
             }
             else {
             if (responseArray.count > 4) {
                 NSMutableArray *subArray = [[responseArray subarrayWithRange:NSMakeRange(0, 5)]mutableCopy];
                 completion((NSMutableArray *) subArray);
             }
             else
             {
                 completion((NSMutableArray *) responseArray);
             }
             }
         }
     }];
}

@end
