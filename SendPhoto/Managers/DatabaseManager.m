//
//  DatabaseManager.m
//  SendPhoto
//
//  Created by Александр on 04.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "DatabaseManager.h"

NSString *databaseFileName = @"db.sqlite";

@interface DatabaseManager()
@property(nonatomic, strong) FMDatabase *db;
@end

@implementation DatabaseManager

+ (id)sharedManager {
    
    static id singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

- (id)init {
    if (self == [super self]) {
        NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *pathToDatabase = [documentsDir stringByAppendingPathComponent:databaseFileName];
    }
    return self;
}

@end
