//
//  HobbyModel.h
//  MyAwesomeApp
//
//  Created by Infinum on 11/11/15.
//  Copyright © 2015 JetonFejza. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HobbyModel : JSONModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *genre;

@end
