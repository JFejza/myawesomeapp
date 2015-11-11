//
//  APIOperationManager.m
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import "APIOperationManager.h"

@implementation APIOperationManager

- (id)init
{
    if (self = [self initWithBaseURL:[NSURL URLWithString:@"http://demo8664105.mockable.io/"]]) {
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.requestSerializer = serializer;
    }
    
    return self;
}

+ (instancetype)manager
{
    return [[APIOperationManager alloc] init];
}

@end
