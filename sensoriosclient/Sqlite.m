//
//  sqlite.m
//  sensorDemo
//
//  Created by user on 14-9-9.
//  Copyright (c) 2014年 bnrc. All rights reserved.
//

#import "Sqlite.h"

@implementation Sqlite

@synthesize db;

-(id)init
{
    return self;
}

//obtain document directory
-(NSString *)dataFilePath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"!!!!!!!!!%@", documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:@"sensor.sqlite"];
    
}

//create and open database
-(BOOL)openDB
{
    NSString *path = [self dataFilePath];
    //NSLog(@"path: %@", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL find = [fileManager fileExistsAtPath:path];
    if(find)
    {
        //NSLog(@"Database existed!");
        //打开数据库，这里的[path UTF8String]是将NSString转换为C字符串
        //因为SQLite3是采用可移植的C(而不是Objective-C)编写的，它不知道什么是NSString.
        if(sqlite3_open([path UTF8String], &db) != SQLITE_OK)
        {
            //如果打开数据库失败则关闭数据库
            sqlite3_close(self.db);
            NSLog(@"Error: open database file.");
            return NO;
        }
        
        [self createPicTable:self.db];
        [self createDataTable:self.db];
        [self createSaveTable:self.db];
        return YES;
    }
    
    //如果发现数据库不存在则利用sqlite3_open创建数据库（上面已经提到过），与上面相同，路径要转换为C字符串
    if(sqlite3_open([path UTF8String], &db) == SQLITE_OK) {
        
        //创建一个新表
       // NSLog(@"create database failed!");
        [self createPicTable:self.db];
        [self createDataTable:self.db];
        [self createSaveTable:self.db];
        return YES;
    } else {
        //如果创建并打开数据库失败则关闭数据库
        sqlite3_close(self.db);
       // NSLog(@"%d",sqlite3_open([path UTF8String], &db));
        NSLog(@"Error: open database file.");
        return NO;
    }
    
    return NO;
}

//create Pictable
-(BOOL)createPicTable:(sqlite3 *)sqlitedb
{
    
    char *sql = "create table if not exists PicInfo(ID INTEGER PRIMARY KEY AUTOINCREMENT, picID integer, picTopic text, xDirect float, yDirect float, zDirect float, longitude float, latitude float, altitude float, exposure integer, focal float, aperture float, width int, height int)";//
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    
    if(sqlReturn != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement:create test table.");
        return NO;
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);//释放sqlite3_stmt
    
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create table test");
        return NO;
    }
    //NSLog(@"Create table 'PicInfo' successed.");
   
    return YES;
}

-(BOOL)insertPicList:(PicInfo *)insertList
{
    //先判断数据库是否打开
    if ([self openDB]) {
        
        sqlite3_stmt *statement;
        
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        static char *sql = "INSERT INTO PicInfo(picID, picTopic, xDirect, yDirect, zDirect, longitude, latitude, altitude, exposure, focal, aperture, width, height) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        int success2 = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            NSLog(@"Error: failed to insert:PicInfo");
            sqlite3_close(db);
            return NO;
        }
        
        //这里的数字1，2，3代表上面的第几个问号，这里将三个值绑定到三个绑定变量
        sqlite3_bind_int(statement, 1, insertList.picID);
        sqlite3_bind_text(statement, 2, [insertList.picTopic UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(statement, 3, insertList.xDirect);
        sqlite3_bind_double(statement, 4, insertList.yDirect);
        sqlite3_bind_double(statement, 5, insertList.zDirect);
        sqlite3_bind_double(statement, 6, insertList.longitude);
        sqlite3_bind_double(statement, 7, insertList.latitude);
        sqlite3_bind_double(statement, 8, insertList.altitude);
        sqlite3_bind_int(statement, 9, insertList.exposure);
        sqlite3_bind_double(statement, 10, insertList.focal);
        sqlite3_bind_double(statement, 11, insertList.aperture);
        sqlite3_bind_int(statement, 12, insertList.width);
        sqlite3_bind_int(statement, 13, insertList.height);
        
        
        //执行插入语句
        success2 = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果插入失败
        if (success2 == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database with message.");
            //关闭数据库
            sqlite3_close(db);
            return NO;
        }
        NSLog(@"Insert PicInfo successfully!");
        //关闭数据库
        sqlite3_close(db);
        return YES;
    }
    return NO;
}

- (BOOL) deletePicList:(PicInfo *)deletList
{
    if ([self openDB]) {
        
        sqlite3_stmt *statement;
        //组织SQL语句
        static char *sql = "delete from PicInfo where picID = ?";
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to delete");
            sqlite3_close(db);
            return NO;
        }
        
        sqlite3_bind_int(statement, 1, deletList.picID);
        
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to delete the database with message.");
            //关闭数据库
            sqlite3_close(db);
            return NO;
        }
        //执行成功后依然要关闭数据库
        sqlite3_close(db);
        return YES;
    }
    return NO;
    
}

//create Datatable
-(BOOL)createDataTable:(sqlite3 *)sqlitedb
{
    
    char *sql = "create table if not exists DataInfo(ID INTEGER PRIMARY KEY AUTOINCREMENT, dataID long, light float, sound float, creatTime integer, charge integer, battery integer, netState integer, longitude float, latitude float, altitude float)";//
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    
    if(sqlReturn != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement:create test table.");
        return NO;
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);//释放sqlite3_stmt
    
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create table test");
        return NO;
    }
    //NSLog(@"Create table 'DataInfo' successed.");
    
    return YES;
}

-(BOOL)insertDataList:(CollectionData *)insertList
{
    //先判断数据库是否打开
    if ([self openDB]) {
        
        sqlite3_stmt *statement;
        
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        static char *sql = "INSERT INTO DataInfo(dataID, light, sound, creatTime, charge, battery, netState, longitude, latitude, altitude) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        int success2 = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            NSLog(@"Error: failed to insert:DataInfo");
            sqlite3_close(db);
            return NO;
        }
        
        //这里的数字1，2，3代表上面的第几个问号，这里将三个值绑定到三个绑定变量
        sqlite3_bind_int(statement, 1, insertList.dataId);
        sqlite3_bind_double(statement, 2, insertList.lightIntensity);
        sqlite3_bind_double(statement, 3, insertList.soundIntensity);
        sqlite3_bind_int(statement, 4, insertList.createdTime);
        sqlite3_bind_int(statement, 5, insertList.chargeState);
        sqlite3_bind_int(statement, 6, insertList.batteryState);
        sqlite3_bind_int(statement, 7, insertList.netState);
        sqlite3_bind_double(statement, 8, insertList.longitude);
        sqlite3_bind_double(statement, 9, insertList.latitude);
        sqlite3_bind_double(statement, 10, insertList.altitude);
        
        //执行插入语句
        success2 = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果插入失败
        if (success2 == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database with message.");
            //关闭数据库
            sqlite3_close(db);
            return NO;
        }
        NSLog(@"Insert DataInfo successfully!");
        //关闭数据库
        sqlite3_close(db);
        return YES;
    }
    return NO;
}

-(BOOL) deleteDataList:(CollectionData *)deleteList
{
    return FALSE;
}

//create Datatable
-(BOOL)createSaveTable:(sqlite3 *)sqlitedb
{
    
    char *sql = "create table if not exists PicSave(ID INTEGER PRIMARY KEY AUTOINCREMENT, picID int, picTopic text, filePath text, tag int)";//
    sqlite3_stmt *statement;
    NSInteger sqlReturn = sqlite3_prepare_v2(db, sql, -1, &statement, nil);
    
    if(sqlReturn != SQLITE_OK)
    {
        NSLog(@"Error: failed to prepare statement:create table.");
        return NO;
    }
    
    int success = sqlite3_step(statement);
    sqlite3_finalize(statement);//释放sqlite3_stmt
    
    if ( success != SQLITE_DONE) {
        NSLog(@"Error: failed to dehydrate:create table");
        return NO;
    }
    //NSLog(@"Create table 'PicSave' successed.");
    
    return YES;
}

-(BOOL)insertSaveList:(PicSave *)insertList
{
    //先判断数据库是否打开
    if ([self openDB]) {
        
        sqlite3_stmt *statement;
        
        //这个 sql 语句特别之处在于 values 里面有个? 号。在sqlite3_prepare函数里，?号表示一个未定的值，它的值等下才插入。
        static char *sql = "INSERT INTO PicSave(picID, picTopic, filePath, tag) VALUES(?, ?, ?, ?)";
        
        int success2 = sqlite3_prepare_v2(db, sql, -1, &statement, NULL);
        if (success2 != SQLITE_OK) {
            NSLog(@"Error: failed to insert:PicSave");
            sqlite3_close(db);
            return NO;
        }
        
        //这里的数字1，2，3代表上面的第几个问号，这里将三个值绑定到三个绑定变量
        sqlite3_bind_int(statement, 1, insertList.picID);
        sqlite3_bind_text(statement, 2, [insertList.picTopic UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [insertList.filePath UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 4, insertList.tag);
        
        //执行插入语句
        success2 = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        
        //如果插入失败
        if (success2 == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database with message.");
            //关闭数据库
            sqlite3_close(db);
            return NO;
        }
        NSLog(@"Insert PicSave successfully!");
        //关闭数据库
        sqlite3_close(db);
        return YES;
    }
    return NO;
}

-(BOOL) deleteSaveList:(PicSave *)deleteList
{
    return FALSE;
}

-(NSMutableArray *)getFilePath
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    //判断数据库是否打开
    if ([self openDB]) {
        NSLog(@"Open PicSave");
        sqlite3_stmt *statement = nil;
        //sql语句
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from PicSave where tag=0"];
        const char *sql = [querySQL UTF8String];
        //        char *sql = "SELECT * FROM testTable WHERE testName like ?";//这里用like代替=可以执行模糊查找，原来是"SELECT * FROM testTable WHERE testName = ?"
        if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement with message:search Value.");
            return NO;
        } else {
            //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值。
            while (sqlite3_step(statement) == SQLITE_ROW) {
                PicSave *search = [[PicSave alloc]init];
                char* searchText= (char*)sqlite3_column_text(statement,3);
                search.filePath = [NSString stringWithUTF8String:searchText];
                NSLog(@"Search Result:file path==%@",search.filePath);
                [array addObject:search.filePath];
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }

    return array;
    
}



@end


