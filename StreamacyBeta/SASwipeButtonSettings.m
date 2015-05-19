//
//  SASwipeButtonSettings.m
//  Streamacy
//
//  Created by Andrew Friedman on 4/20/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SASwipeButtonSettings.h"

@implementation SASwipeButtonSettings

+ (void)setSwipeSettings:(MGSwipeSettings *)settings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings
{
    settings.threshold = 9999;
    settings.transition = MGSwipeTransitionClipCenter;
    expansionSettings.buttonIndex = 0;
    expansionSettings.threshold = 1;
    expansionSettings.expansionLayout = MGSwipeExpansionLayoutCenter;
    expansionSettings.fillOnTrigger = NO;
    expansionSettings.animationDuration = .05;
}

+ (NSArray *)rightButtons
{
    MGSwipeButton *rightButton = [MGSwipeButton buttonWithTitle:@"Send" backgroundColor:[UIColor colorWithRed:0.914 green:0.921 blue:0.924 alpha:1]];
    rightButton.buttonWidth = 85;
    return @[rightButton];
}

+ (NSArray *)leftButtons
{
    MGSwipeButton *leftButton = [MGSwipeButton buttonWithTitle:@"Queue" backgroundColor:[UIColor colorWithRed:0.914 green:0.921 blue:0.924 alpha:1]];
    leftButton.buttonWidth = 85;
    return @[leftButton];
}

+(UIColor *)rightExpansionColor
{
    //Universal Purple
    return [UIColor colorWithRed:0.201 green:0.737 blue:0.599 alpha:1];
}

+(UIColor *)leftExpansionColor{
    
    //Torqouise
    return [UIColor colorWithRed:0.484 green:0.403 blue:0.884 alpha:1];
}

//Action for swiping a cell left to right. Queue Action
+(void)performActionForLeftSwipeWithTrack:(TrackObject *)track
{
    NSLog(@"Left to Right. Queue");
}

//Action for swiping a cell right to left. Send Action
+(void)performActionForRightSwipeWithTrack:(TrackObject *)track
{
    NSLog(@"Right to Left. Send");
}


@end
