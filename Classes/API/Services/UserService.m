//
//  UserService.m
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import "UserService.h"
#import "APIOperationManager.h"
#import "UserModel.h"

@implementation UserService

+ (void)getUsersWithCompletion:(void (^)(NSArray *users))completion failure:(void (^)(NSError *error))failure
{
    APIOperationManager *manager = [APIOperationManager manager];
    
    [manager GET:@"users" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSArray *models = [UserModel arrayOfModelsFromDictionaries:operation.responseObject error:&error];
        if (error) {
            if (failure) {
                failure(error);
            }
        } else if (completion) {
            completion(models);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
