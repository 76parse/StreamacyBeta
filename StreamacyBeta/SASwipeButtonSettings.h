//
//  SASwipeButtonSettings.h
//  Streamacy
//
//  Created by Andrew Friedman on 4/20/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGSwipeTableCell.h"
#import "TrackObject.h"

@interface SASwipeButtonSettings : NSObject

+ (void)setSwipeSettings:(MGSwipeSettings *)settings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings;

+(NSArray *)rightButtons;
+(NSArray *)leftButtons;

+(UIColor *)rightExpansionColor;
+(UIColor *)leftExpansionColor;


+(void)performActionForLeftSwipeWithTrack:(TrackObject *)track;
+(void)performActionForRightSwipeWithTrack:(TrackObject *)track;


@end
