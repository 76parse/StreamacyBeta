//
//  SAActionSheetAnimator.m
//  StreamacyBeta
//
//  Created by Andrew Friedman on 5/20/15.
//  Copyright (c) 2015 Andrew Friedman. All rights reserved.
//

#import "SAActionSheetAnimator.h"

@implementation SAActionSheetAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    if (self.presenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        int frameHeight = fromViewController.view.frame.size.height;
        CGRect startFrame = fromViewController.view.frame;
        startFrame.origin.y = frameHeight;
        toViewController.view.frame = startFrame;
      
        __block CGRect endFrame = toViewController.view.frame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            endFrame.origin.y = 0;
            endFrame.size.height +=30;
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            endFrame.size.height -= 30;
            toViewController.view.frame = endFrame;
            [transitionContext completeTransition:YES];
        }];
        
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        CGRect endFrame = toViewController.view.frame;
        endFrame.origin.y = 0;
        fromViewController.view.frame = endFrame;
        
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:.9 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            int frameHeight = toViewController.view.frame.size.height;
            CGRect startFrame = fromViewController.view.frame;
            startFrame.origin.y = frameHeight;
            fromViewController.view.frame = startFrame;
           
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            //Because there is a bug in Xcode apparently.
            [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
        }];

    }
}

@end
