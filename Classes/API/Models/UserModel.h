//
//  UserModel.h
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HobbyModel.h"

@protocol HobbyModel;

@interface UserModel : JSONModel

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray<HobbyModel> *bands;
@property (strong, nonatomic) NSArray<HobbyModel> *games;

@end
