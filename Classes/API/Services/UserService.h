//
//  UserService.h
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserService : NSObject

+ (void)getUsersWithCompletion:(void (^)(NSArray *users))completion failure:(void (^)(NSError *error))failure;

@end
