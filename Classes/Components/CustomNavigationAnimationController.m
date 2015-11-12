//
//  CustomNavigationAnimationController.m
//  MyAwesomeApp
//
//  Created by Infinum on 12/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#define kTransitionDuration 0.8

#import "CustomNavigationAnimationController.h"

@interface CustomNavigationAnimationController ()

@end

@implementation CustomNavigationAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    CGFloat direction = self.reverse ? -1 : 1;
    CGFloat m34Const = -0.005;
    
    //Prepare animation values
    toView.layer.anchorPoint = CGPointMake(direction == 1 ? 0 : 1, 0.5);
    fromView.layer.anchorPoint = CGPointMake(direction == 1 ? 1 : 0, 0.5);
    CATransform3D viewFromTransform = CATransform3DMakeRotation(direction * M_PI_2, 0.0, 1.0, 0.0);
    CATransform3D viewToTransform = CATransform3DMakeRotation(-direction * M_PI_2, 0.0, 1.0, 0.0);
    viewFromTransform.m34 = m34Const;
    viewToTransform.m34 = m34Const;
    containerView.transform = CGAffineTransformMakeTranslation(direction * containerView.frame.size.width / 2.0, 0);
    toView.layer.transform = viewToTransform;
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:kTransitionDuration animations:^{
        containerView.transform = CGAffineTransformMakeTranslation(-direction * containerView.frame.size.width / 2.0, 0);
        fromView.layer.transform = viewFromTransform;
        toView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        
        //Normalise values
        containerView.transform = CGAffineTransformIdentity;
        fromView.layer.transform = CATransform3DIdentity;
        toView.layer.transform = CATransform3DIdentity;
        fromView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        toView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        //Checks if transition was cancelled - main thread blocked or smth like that
        if ([transitionContext transitionWasCancelled]) {
            [toView removeFromSuperview];
        } else {
            [fromView removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
