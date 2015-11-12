//
//  CoreDataManager.m
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+ (void)addUserFromAPIModel:(UserModel *)user
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CDUser *coreDataUser = [CDUser MR_createEntityInContext:localContext];
        
        for (HobbyModel *hobby in user.games) {
            CDHobby *coreDataHobby = [CDHobby MR_createEntityInContext:localContext];
            coreDataHobby.name = hobby.name;
            coreDataHobby.genre = hobby.genre;
            coreDataHobby.link = hobby.link;
            [coreDataUser addGamesObject:coreDataHobby];
        }
        
        for (HobbyModel *hobby in user.bands) {
            CDHobby *coreDataHobby = [CDHobby MR_createEntityInContext:localContext];
            coreDataHobby.name = hobby.name;
            coreDataHobby.genre = hobby.genre;
            coreDataHobby.link = hobby.link;
            [coreDataUser addBandsObject:coreDataHobby];
        }
        
        coreDataUser.name = user.name;
        coreDataUser.apiID = user.userID;
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSArray *saved = [CDUser MR_findAll];
        NSLog(@"Saved users: %@", saved);
    }];
}

+ (void)removeUser:(CDUser *)coreDataUser
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [coreDataUser MR_deleteEntityInContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSArray *saved = [CDUser MR_findAll];
        NSLog(@"Deleted a user, saved users: %@", saved);
    }];
}

+ (BOOL)atLeastOneItemPresent
{
    NSArray *saved = [CDUser MR_findAll];
    if (saved.count == 0) {
        return NO;
    }
    return YES;
}

@end
