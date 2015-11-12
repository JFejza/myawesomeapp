//
//  CDUser+CoreDataProperties.h
//  MyAwesomeApp
//
//  Created by Infinum on 12/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *apiID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<CDHobby *> *bands;
@property (nullable, nonatomic, retain) NSSet<CDHobby *> *games;

@end

@interface CDUser (CoreDataGeneratedAccessors)

- (void)addBandsObject:(CDHobby *)value;
- (void)removeBandsObject:(CDHobby *)value;
- (void)addBands:(NSSet<CDHobby *> *)values;
- (void)removeBands:(NSSet<CDHobby *> *)values;

- (void)addGamesObject:(CDHobby *)value;
- (void)removeGamesObject:(CDHobby *)value;
- (void)addGames:(NSSet<CDHobby *> *)values;
- (void)removeGames:(NSSet<CDHobby *> *)values;

@end

NS_ASSUME_NONNULL_END
