//
//  FragmentDao.h
//  PrivatePlot
//
//  Created by Kino on 13-12-9.
//  Copyright (c) 2013年 kino. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseDao.h"
#import "Fragment.h"

@interface FragmentDao : BaseDao

+ (FragmentDao *)shareInstance;

- (void)insertRecord:(Fragment *)model;

- (void)deleteRecord:(Fragment *)model;

- (void)updateRecord:(Fragment *)model;

- (NSMutableArray *)getAllRecord;

@end
