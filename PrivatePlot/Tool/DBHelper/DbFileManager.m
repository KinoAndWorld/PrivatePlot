//
//  DbFileManager.m
//
//  Created by fox wang on 12-3-23.
//

#import "DbFileManager.h"
@implementation DbFileManager
//改成library - Cache
+ (NSString *)documentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//创建数据库
+ (void)checkWithCreateDbFile:(NSString *)fullPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbFileName = k_DB_Name;
    BOOL found = [fileManager fileExistsAtPath:fullPath];
    if(!found)
    {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *defaultDBFilePath =
        [resourcePath stringByAppendingPathComponent:dbFileName];
        
        found = [fileManager copyItemAtPath:defaultDBFilePath
                                     toPath:fullPath
                                      error:&error];
        //[self addSkipBackupAttributeToFileAtPath:fullPath];
        if (!found)
        {
            NSAssert1(0,
                      @"创建数据库失败 '%@'.",
                      [error localizedDescription]);
        }
    }
}

+ (NSString *)dbFilePath
{
    NSString *dbFileName = k_DB_Name;
    NSString *documentsDirectory = [DbFileManager documentPath];
    NSLog(@"%@",documentsDirectory);
    NSString *dbFilePath =
    [documentsDirectory stringByAppendingPathComponent:dbFileName];
    
    [DbFileManager checkWithCreateDbFile:dbFilePath];
    
    return dbFilePath;
}

+ (BOOL)createFolderInDocment:(NSString *)folderName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [DbFileManager documentPath];
    NSString *foldFullPath =  [documentsDirectory stringByAppendingPathComponent:folderName];
    return [fileManager createDirectoryAtPath:foldFullPath withIntermediateDirectories:YES attributes:nil error:nil];
}

/*
+ (BOOL)addSkipBackupAttributeToFileAtPath:(NSString *)aFilePath
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:aFilePath]) return NO;
    NSError *error = nil;
    BOOL success = NO;
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 5.1f){
        success = [[NSURL fileURLWithPath:aFilePath] setResourceValue:[NSNumber numberWithBool:YES]
                                                               forKey:NSURLIsExcludedFromBackupKey
                                                                error:&error];
    }
    else if ([systemVersion isEqualToString:@"5.0.1"]){
        const char* filePath = [aFilePath fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        success = (result == 0);
    }else{
        NSLog(@"Can not add 'do no back up' attribute at systems before 5.0.1");
    }
    
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [aFilePath lastPathComponent], error);
    }
    return success;
}
 */

@end
