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
        
        //create a view with the same background color to cover up background on bounce effect
        UIView *bottomCover = [[UIView alloc]initWithFrame:CGRectMake(0, startFrame.size.height-30, startFrame.size.width, 30)];
        [bottomCover setBackgroundColor:[UIColor colorWithRed:0.956 green:0.962 blue:0.956 alpha:1]];
        [transitionContext.containerView insertSubview:bottomCover belowSubview:toViewController.view];
        
        __block CGRect endFrame = toViewController.view.frame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            endFrame.origin.y = 0;
            toViewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            [bottomCover removeFromSuperview];
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
