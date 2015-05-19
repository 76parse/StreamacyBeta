//
//  Helpers.m
//  Streamacy
//
//  Created by Andrew Friedman on 4/7/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "Helpers.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation Helpers

+ (UIImage *)blurredImageWithImage:(UIImage *)sourceImage
{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:50.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    return retVal;
}

+ (NSString *)timeFormatted:(int)totalSeconds
{
    int temp = (int)totalSeconds / 1000;
    int minutes = (temp / 60);
    int seconds = temp % 60;
    
    if (seconds < 10)
        return [NSString stringWithFormat:@"%i:0%i", minutes, seconds];
    else
        return [NSString stringWithFormat:@"%i:%i", minutes, seconds];
}



@end
