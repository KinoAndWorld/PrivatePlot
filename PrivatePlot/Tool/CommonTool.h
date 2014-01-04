//
//  CommonTool.h
//  PrivatePlot
//
//  Created by Kino on 13-12-10.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

#pragma mark # HDU显示
+ (void)showMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message withTime:(float)time;

+ (void)showMessage:(NSString *)message withImage:(UIImage *)image withTime:(float)time;

+ (void)showProgress:(UIView *)view;

+ (void)showProgress:(UIView *)view AndMessage:(NSString *) message;

+ (void)hideProgress;

#pragma mark # 通用计算

+ (long long)folderSizeAtPathAll:(NSString*) folderPath;

+ (int)getAttributedStringHeightWithString:(NSAttributedString *)string WidthValue:(int)width;

#pragma mark # 常量判断

+ (bool)isIOS7;

@end
