//
//  DbFileManager.h
//
//  Created by fox wang on 12-3-23.
//
//针对数据库文件的封装类

#define k_DB_Name @"PrivatePlot.sqlite"

#define K_DBTable_Fragment @"Fragment"


#import <Foundation/Foundation.h>

@interface DbFileManager : NSObject

+ (NSString *)documentPath;

+ (void)checkWithCreateDbFile:(NSString *)fullPath;

+ (NSString *)dbFilePath;

+ (BOOL)createFolderInDocment:(NSString *)folderName;


@end
