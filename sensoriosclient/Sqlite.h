//
//  sqlite.h
//  sensorDemo
//
//  Created by user on 14-9-9.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PicInfo.h"

#define dbName @"sensor.sqlite"

@interface Sqlite : NSObject{
    sqlite3 *db;
}

@property (nonatomic) sqlite3 *db;
-(BOOL) create:(sqlite3 *)sqlitedb;
-(BOOL) insertList:(PicInfo *)insertList;
-(BOOL) deleteList:(PicInfo *)deleteList;
//-(NSMutableArray*) getList;

@end


