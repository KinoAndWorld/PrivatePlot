//
//  CommonTool.m
//  PrivatePlot
//
//  Created by Kino on 13-12-10.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "CommonTool.h"
#import "MBProgressHUD.h"

#import <CoreText/CoreText.h>

#include <sys/stat.h>

static MBProgressHUD *proHUD;

@implementation CommonTool


+ (void)showMessage:(NSString *)message{
    [self showMessage:message withImage:nil withTime:1.0];
}

+ (void)showMessage:(NSString *)message withTime:(float)time{
    [self showMessage:message withImage:nil withTime:time];
}

+ (void)showMessage:(NSString *)message withImage:(UIImage *)image withTime:(float)time{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
	[[UIApplication sharedApplication].keyWindow addSubview:HUD];
	
    HUD.customView = [[UIImageView alloc] initWithImage:image];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.labelText = message;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:time];
    
}

+ (void)showProgress:(UIView *)view{
    
    [self hideProgress];
    
    proHUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:proHUD];
    [proHUD show:YES];
}

+ (void)showProgress:(UIView *)view AndMessage:(NSString *) message{
    
    [self hideProgress];
    proHUD = [[MBProgressHUD alloc] initWithView:view];
	[view addSubview:proHUD];
    proHUD.labelText = message;
    [proHUD show:YES];
}

+ (void)hideProgress{
    
    if(proHUD != nil){
        [proHUD hide:YES];
        proHUD = nil;
    }
}


#pragma mark - 常用计算

+ (long long) fileSizeAtPath:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}
// 循环调用fileSizeAtPath来获取一个目录所占空间大小
+ (long long) folderSizeAtPathAll:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

+ (int)getAttributedStringHeightWithString:(NSAttributedString *)string WidthValue:(int)width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    NSLog(@"string=%@",string);
    CTLineRef line = (__bridge CTLineRef)[linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}

#pragma mark # 常量判断

NSUInteger DeviceSystemMajorVersion();
NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

static bool IOS7;
static bool isCalcIOS7;

+ (bool)isIOS7{
    if (isCalcIOS7 == false) {
        isCalcIOS7 = true;
        IOS7 = DeviceSystemMajorVersion() >= 7;
    }
    return IOS7;
}

@end
