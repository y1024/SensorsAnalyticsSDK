//
//  SensorsAnalyticsCache.m
//  SensorsAnalyticsSDK
//
//  Created by 杜晓星 on 2017/11/29.
//  Copyright © 2017年 SensorsData. All rights reserved.
//

#import "SensorsAnalyticsCache.h"
#import <CommonCrypto/CommonDigest.h>

@interface SensorsAnalyticsCache ()

@property (nonatomic,strong)NSFileManager *fileManager;

@property (nonatomic,copy)NSString *diskCachePath;

@end

static SensorsAnalyticsCache *_cache = nil;

@implementation SensorsAnalyticsCache

+ (instancetype)instance {
    if (_cache) {
        return _cache;
    }else{
        return  [[super allocWithZone:nil]init];
    }
}


- (instancetype)init {
    if (!_cache) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _cache = [super init];
            [_cache commonInit];
        });

    }
    return _cache;
}

- (void)commonInit {
    NSString *home = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *full = [home stringByAppendingPathComponent:@"com.snapshotImage.SensorsAnalyticsCache"];
    NSFileManager *fileManager = self.fileManager;
    if (![fileManager fileExistsAtPath:full]) {
        [fileManager createDirectoryAtPath:full withIntermediateDirectories:true attributes:nil error:nil];
    }
}


- (void)storeImageDataToDisk:(NSData *)imageData forKey:(NSString *)key {
    if (!imageData) {
        return;
    }
    
    if (![_fileManager fileExistsAtPath:_diskCachePath]) {
        [_fileManager createDirectoryAtPath:_diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    // get cache Path for image key
    NSString *cachePathForKey = [self defaultCachePathForKey:key];
    [_fileManager createFileAtPath:cachePathForKey contents:imageData attributes:nil];
    
}

- (NSString *)defaultCachePathForKey:(NSString *)key {
    return [self cachePathForKey:key inPath:self.diskCachePath];
}

- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    NSString *filename = [self cachedFileNameForKey:key];
    return [path stringByAppendingPathComponent:filename];
}



#pragma mark SDImageCache (private)

- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
}


#pragma mark lazy load

- (NSFileManager*)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (NSString*)diskCachePath {
    if (!_diskCachePath) {
        NSString *home = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *full = [home stringByAppendingPathComponent:@"com.snapshotImage.SensorsAnalyticsCache"];
        _diskCachePath = full;
    }
    return _diskCachePath;
}

#pragma mark + allocWithZone
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self instance];
}
#pragma mark - copyWithZone
- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}


@end
