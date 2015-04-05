//
//  PhotoManager.m
//  SendPhoto
//
//  Created by Александр on 31.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "PhotoManager.h"
#import "Photo.h"

@interface PhotoManager ()
@property (nonatomic, strong) NSMutableArray *photosArray;
//создать dispatch_barrier 1. Создать конкурентную очередь
@property (nonatomic, strong) dispatch_queue_t concurrentPhotoQueue;
@end

@implementation PhotoManager

+ (instancetype)sharedManager
{
    static PhotoManager *sharedPhotoManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPhotoManager = [[PhotoManager alloc] init];
    });
    
    return sharedPhotoManager;
}

- (id)init {
    if (self == [super self]) {
        _photosArray = [NSMutableArray array];
        
        //создать dispatch_barrier 1. Создать конкурентную очередь
        _concurrentPhotoQueue = dispatch_queue_create("com.photoQueue",DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSArray *)photos {

    __block NSArray *array;
    
    //создать dispatch_barrier 2. Для геттеров использовать dispatch_sync
    dispatch_sync(self.concurrentPhotoQueue, ^{
        array = _photosArray;
    });
    return array;
}

- (void)addPhoto:(Photo *)photo {

    if (photo) {
        
        //создать dispatch_barrier 3. Для сеттеров использовать dispatch_barrier_async
        dispatch_barrier_async(self.concurrentPhotoQueue, ^{
            [_photosArray addObject:photo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self postContentAddedNotification];
            });
        });
    }
}

@end
