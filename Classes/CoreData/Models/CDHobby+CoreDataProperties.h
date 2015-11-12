//
//  CDHobby+CoreDataProperties.h
//  MyAwesomeApp
//
//  Created by Infinum on 12/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDHobby.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDHobby (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *genre;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) CDUser *user;

@end

NS_ASSUME_NONNULL_END
