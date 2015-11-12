//
//  CustomNavigationInteractionController.h
//  MyAwesomeApp
//
//  Created by Infinum on 12/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomNavigationInteractionController : UIPercentDrivenInteractiveTransition

@property (assign, nonatomic) BOOL transitionIsInProgress;

- (void)attachToVC:(UIViewController *)vc;

@end
