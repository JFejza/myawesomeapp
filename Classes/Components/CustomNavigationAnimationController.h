//
//  CustomNavigationAnimationController.h
//  MyAwesomeApp
//
//  Created by Infinum on 12/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomNavigationAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) BOOL reverse;

@end
