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
#import "CollectionData.h"

#define dbName @"sensor.sqlite"

@interface Sqlite : NSObject{
    sqlite3 *db;
}

@property (nonatomic) sqlite3 *db;
//-(BOOL) createPicTable:(sqlite3 *)sqlitedb;
-(BOOL) insertPicList:(PicInfo *)insertList;
-(BOOL) deletePicList:(PicInfo *)deleteList;

-(BOOL) insertDataList:(CollectionData *)insertList;
-(BOOL) deleteDataList:(CollectionData *)deleteList;
//-(NSMutableArray*) getList;

@end


