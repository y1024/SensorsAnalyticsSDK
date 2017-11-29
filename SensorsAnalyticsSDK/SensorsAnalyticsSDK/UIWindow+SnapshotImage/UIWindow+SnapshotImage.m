//
//  UIWindow+SnapshotImage.m
//  SensorsAnalyticsSDK
//
//  Created by 杜晓星 on 2017/11/29.
//  Copyright © 2017年 SensorsData. All rights reserved.
//

#import "UIWindow+SnapshotImage.h"

@implementation UIWindow (SnapshotImage)

- (UIImage *)snapshotImage {
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}


@end
