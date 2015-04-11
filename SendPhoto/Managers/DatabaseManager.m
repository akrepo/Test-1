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
        
        /*
        NSError *error;
        if ([[NSFileManager defaultManager] fileExistsAtPath:pathToDatabase]) {
            [[NSFileManager defaultManager] removeItemAtPath:pathToDatabase error:&error];
            
            if (!error) {
                NSLog(@"Database is deleted!");
            }else {
                NSLog(@"Database is NOT deleted!");
            }
        }
        */
        
        self.db = [[FMDatabase alloc] initWithPath:pathToDatabase];
        
        [self.db open];
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id integer primary key autoincrement, url text)",databaseTableName];
        
        if ([self.db executeStatements:sql]) {
            NSLog(@"succsess");
        }
        
        [self.db close];
        
    }
    return self;
}

- (BOOL)insertPhoto:(Photo *)photo {
    [self.db open];
    
    //[database executeUpdate:@"INSERT INTO tableName (fieldName, fieldName, fieldName, fieldName) VALUES (?, ?, ?, ?)", [NSNumber numberWithLong:fieldVariable], [NSNumber numberWithLong:fieldVariable], [NSString stringWithFormat:@"%@", fieldVariable], [NSNumber numberWithInt:fieldVariable], nil];
    
    //NSString *query = [NSString stringWithFormat:@"insert into user values ('%@', %d)",@"brandontreb", 25];
    
    //BOOL succsess = [self.db executeUpdate:@"INSERT INTO SelectedPhotos (url) VALUES ('urltyt')" withArgumentsInArray:nil];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (url) VALUES ('%@')",databaseTableName, [photo URL]];
    BOOL succsess = [self.db executeUpdate:sql];
    
    if (succsess) {
        NSLog(@"insert Photo: OK");
    }else {
        NSLog(@"insert Photo: ERROR");
    }
    
    [self.db close];
    
    return succsess;
}

- (BOOL)insertURLString:(NSString *)string {
    [self.db open];
    
    //[database executeUpdate:@"INSERT INTO tableName (fieldName, fieldName, fieldName, fieldName) VALUES (?, ?, ?, ?)", [NSNumber numberWithLong:fieldVariable], [NSNumber numberWithLong:fieldVariable], [NSString stringWithFormat:@"%@", fieldVariable], [NSNumber numberWithInt:fieldVariable], nil];
    
    //NSString *query = [NSString stringWithFormat:@"insert into user values ('%@', %d)",@"brandontreb", 25];
    
    //BOOL succsess = [self.db executeUpdate:@"INSERT INTO SelectedPhotos (url) VALUES ('urltyt')" withArgumentsInArray:nil];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (url) VALUES ('%@')",databaseTableName, string];
    BOOL succsess = [self.db executeUpdate:sql];
    
    if (succsess) {
        NSLog(@"insert String: OK");
    }else {
        NSLog(@"insert String: ERROR");
    }
    
    [self.db close];
    
    return succsess;
}

- (NSArray *)selectAllURLs {
    [self.db open];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",databaseTableName];
    FMResultSet *set = [self.db executeQuery:sql];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    while (set.next) {
        [arr addObject:[set stringForColumn:@"url"]];
    }
    
    [self.db close];
    
    return arr;
}

- (BOOL)clearDatabase {
    [self.db open];
    
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@",databaseTableName];
    BOOL succsess = [self.db executeUpdate:sql];

    [self.db close];
    
    return succsess;
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
