//
//  DatabaseManager.h
//  SendPhoto
//
//  Created by Александр on 04.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;

@interface DatabaseManager : NSObject

+ (id)sharedManager;
- (BOOL)insertURLString:(NSString *)string;
- (NSArray *)selectAllURLs;
- (BOOL)clearDatabase;

- (BOOL)insertPhoto:(Photo *)photo;

@end
