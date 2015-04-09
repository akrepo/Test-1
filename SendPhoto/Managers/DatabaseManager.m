//
//  DatabaseManager.m
//  SendPhoto
//
//  Created by Александр on 04.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h"
#import "Photo.h"

NSString *databaseFileName = @"db.sqlite";
NSString *databaseTableName = @"SelectedPhotos";

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
        NSLog(@"pathToDatabase:%@",pathToDatabase);
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:pathToDatabase]) {
            self.db = [[FMDatabase alloc] initWithPath:pathToDatabase];
            
            [self.db open];
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id integer primary key autoincrement, type text, url text)",databaseTableName];
            
            if ([self.db executeStatements:sql]) {
                NSLog(@"succsess");
            }
            
            [self.db close];
        }
        
    }
    return self;
}

- (BOOL)insertPhotos:(NSArray *)photos {
    [self.db open];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@",databaseTableName];

    
    for (Photo *photo in photos) {
        [self.db executeQuery:<#(NSString *)#> withArgumentsInArray:<#(NSArray *)#>
    }
    
    [self.db close];
         
         
}

/*
- (void)initilizeDB {
    
    [self.db open];
    
    //NSString *sql = @"create table IF NOT EXISTS SelectedPhotos(id integer primary key autoincrement, name text, image_url text, thumbnail_url text)";
    NSString *sql = @"CREATE TABLE IF NOT EXISTS SelectedPhotos(id integer primary key autoincrement, type text, url text)";
    
    if ([self.db executeStatements:sql]) {
        NSLog(@"succsess");
    }
    

    FMResultSet *resultSet = [self.db executeQuery:@"SELECT COUNT(*) FROM SelectedPhotos"];
    while (resultSet.next) {
        NSLog(@"count = %ld",[resultSet longForColumnIndex:0]);
    }

    
    [self.db close];
}
*/
@end
