//
//  CustomNavigationInteractionController.m
//  MyAwesomeApp
//
//  Created by Infinum on 12/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import "CustomNavigationInteractionController.h"

@interface CustomNavigationInteractionController ()

@property (strong, nonatomic) UINavigationController *navigationController;
@property (assign, nonatomic) BOOL shouldCompleteTransition;

@end

@implementation CustomNavigationInteractionController

- (void)attachToVC:(UIViewController *)vc
{
    self.navigationController = vc.navigationController;
    [self setupGestureRecForView:vc.view];
}

- (void)setupGestureRecForView:(UIView *)view
{
    [view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:pan.view.superview];
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:
        {
            self.transitionIsInProgress = YES;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat value = fminf(fmaxf(translation.x / 200.0, 0.0), 1.0);
            if (value > 0.5) {
                //Traveled more than half - go to end
                self.shouldCompleteTransition = YES;
            }
            [self updateInteractiveTransition:value];
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            self.transitionIsInProgress = NO;
            if (!self.shouldCompleteTransition || pan.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
        }
            
        default:
            break;
    }
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

@end
