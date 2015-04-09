//
//  DatabaseManager.h
//  SendPhoto
//
//  Created by Александр on 04.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

+ (id)sharedManager;
- (BOOL)insertPhotos:(NSArray *)photos;

@end
