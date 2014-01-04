//
//  FragmentDao.m
//  PrivatePlot
//
//  Created by Kino on 13-12-9.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import "FragmentDao.h"


@implementation FragmentDao

static FragmentDao *fragmentInstance = nil;

+ (FragmentDao *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fragmentInstance = [[FragmentDao alloc] init];
    });
    return fragmentInstance;
}

- (NSString *)setTable:(NSString *)sql{
    NSLog(@"%@",[NSString stringWithFormat:sql,  K_DBTable_Fragment]);
    return [NSString stringWithFormat:sql,  K_DBTable_Fragment];
}

- (void)insertRecord:(Fragment *)model{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *roolBack){
        [db executeUpdate:
         [self setTable:@"INSERT INTO %@ (contentText,contentImage,postTime,display) VALUES (?,?,?,?)"],
          model.contentText,
          model.contentImageData,
          model.postTime,
          [NSNumber numberWithBool:model.display]];
    }];
}

- (void)deleteRecord:(Fragment *)model{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *roolBack){
        [db executeUpdate:
         [self setTable:@"DELETE FROM %@ WHERE id = ?"],[NSNumber numberWithInteger:model.ID]];
        NSLog(@"%@",[NSNumber numberWithBool:model.ID]);
    }];
}

- (void)updateRecord:(Fragment *)model{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *roolBack){
        [db executeUpdate:
         [self setTable:@"UPDATE %@ SET contentText = ?,contentImage = ?,postTime=?,display=?) WHERE id =?"],
         model.contentText,
         model.contentImageData,
         model.postTime,
         [NSNumber numberWithBool:model.display],
         [NSNumber numberWithBool:model.ID]];
    }];
}

- (NSMutableArray *)getAllRecord{
    __block NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:0];
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        NSString *strSQL = [NSString stringWithFormat: @"SELECT * FROM %@", K_DBTable_Fragment];
        FMResultSet *rs = [db executeQuery:strSQL];
        while ([rs next]){
            [result addObject:[self rsToObj :rs]];
        }
        [rs close];
    }];
    return result;
}

- (Fragment *)rsToObj:(FMResultSet*)rs
{
    Fragment *fra = [[Fragment alloc] init];
    fra.ID = [rs intForColumn:@"id"];
    fra.contentText = [rs stringForColumn:@"contentText"];
    fra.contentImageData = [rs dataForColumn:@"contentImage"];
    fra.postTime = [rs dateForColumn:@"postTime"];
    fra.display = [rs boolForColumn:@"display"];
    fra.remark = [rs stringForColumn:@"remark"];
    return fra;
}

@end
