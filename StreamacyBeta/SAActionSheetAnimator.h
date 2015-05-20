//
//  SAActionSheetAnimator.h
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/20/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SAActionSheetAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL presenting;
@end
