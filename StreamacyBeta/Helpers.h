//
//  Helpers.h
//  Streamacy
//
//  Created by Andrew Friedman on 4/7/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Helpers : NSObject
+ (UIImage *)blurredImageWithImage:(UIImage *)sourceImage;
+ (NSString *)timeFormatted:(int)totalSeconds;
@end
