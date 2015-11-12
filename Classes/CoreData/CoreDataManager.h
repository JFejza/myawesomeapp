//
//  CoreDataManager.h
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import "UserModel.h"
#import "CDUser+CoreDataProperties.h"
#import "CDHobby+CoreDataProperties.h"

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>

@interface CoreDataManager : NSObject

+ (void)addUserFromAPIModel:(UserModel *)user;
+ (void)removeUser:(CDUser *)coreDataUser;
+ (BOOL)atLeastOneItemPresent;

@end
