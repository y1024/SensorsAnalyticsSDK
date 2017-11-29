//
//  SensorsAnalyticsCache.h
//  SensorsAnalyticsSDK
//
//  Created by 杜晓星 on 2017/11/29.
//  Copyright © 2017年 SensorsData. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SensorsAnalyticsCache : NSObject

+ (instancetype)instance;

- (void)storeImageDataToDisk:(NSData *)imageData forKey:(NSString *)key;

@end
