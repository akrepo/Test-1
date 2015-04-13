//
//  PhotoManager.h
//  SendPhoto
//
//  Created by Александр on 31.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

typedef void (^PhotoProcessingProgressBlock)(CGFloat completionPercentage);
typedef void (^BatchPhotoDownloadingCompletionBlock)(NSError *error);

@interface PhotoManager : NSObject

+ (instancetype)sharedManager;
- (NSArray *)photos;
- (void)addPhoto:(Photo *)photo;
- (void)deleteAllPhotos;
- (void)downloadPhotosWithCompletionBlock:(BatchPhotoDownloadingCompletionBlock)completionBlock;

@end
