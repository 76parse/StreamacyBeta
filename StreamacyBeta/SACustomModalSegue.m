//
//  SACustomModalSegue.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/19/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SACustomModalSegue.h"

@implementation SACustomModalSegue

-(void)perform
{
    [self.sourceViewController presentViewController:self.destinationViewController animated:NO completion:^{
    }];
}

@end
