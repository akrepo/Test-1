//
//  Photo.h
//  SendPhoto
//
//  Created by Александр on 31.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

typedef void(^PhotoDownloadingCompletionBlock)(UIImage *image, NSError *error);
typedef NS_ENUM(NSInteger, PhotoStatus) {
    PhotoStatusDownloading,
    PhotoStatusGoodToGo,
    PhotoStatusFailed,
};

@interface Photo : NSObject

@property (nonatomic, readonly, assign) PhotoStatus status;

/// The original image
- (UIImage *)image;

/// Scaled down image of the original image
- (UIImage *)thumbnail;

- (NSURL *)URL;

- (instancetype)initWithAsset:(ALAsset *)asset;
- (instancetype)initwithURL:(NSURL *)url;
- (instancetype)initwithURL:(NSURL *)url withCompletionBlock:(PhotoDownloadingCompletionBlock)completionBlock;

@end
