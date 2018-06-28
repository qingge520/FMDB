//
//  ViewController.m
//  FMDB_Demo
//
//  Created by RMB on 2018/6/28.
//  Copyright © 2018年 中金盛天技术部. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import <FMDatabase.h>

@interface ViewController () {
    FMDatabase *_db;//FMDB对象
    NSString *_docPath;//路径
    int i;//标记
    int j;//标记
    NSArray *nameArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    nameArray = @[@"呛水的鱼",@"清水的鱼",@"清蒸的鱼",@"红烧的鱼",@"会飞的鱼",@"委屈的鱼"];
    
    //1.获取数据库文件的路径
    _docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",_docPath);
    
    
    //设置数据库名称
    NSString *fileName = [_docPath stringByAppendingPathComponent:@"student.sqlite"];
    
    //2.获取数据库
    _db = [FMDatabase databaseWithPath:fileName];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
}

- (IBAction)newDatabase:(id)sender {
    NSLog(@"新建数据库");
    
    NSString *fileName = [_docPath stringByAppendingPathComponent:@"student.sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];
    if ([_db open]) {
        NSLog(@"打开数据库成功");
    } else {
        NSLog(@"打开数据库失败");
    }
}

- (IBAction)newTable:(id)sender {
    NSLog(@"新建表");
    
    i = 0;
    j = 0;
    
//    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, sex text NOT NULL, hobbies integer NOT NULL);"];
    BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_student (id integer NOT NULL, name text NOT NULL, sex text NOT NULL, hobbies integer NOT NULL);"];
    if (result) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

- (IBAction)addData:(id)sender {
    NSLog(@"添加数据");
    
    NSArray *nameArray = @[@"呛水的鱼",@"清水的鱼",@"清蒸的鱼",@"红烧的鱼",@"会飞的鱼",@"委屈的鱼"];
    if (j == 6) j = 0;
    
    NSString *name = [NSString stringWithFormat:@"%@",nameArray[j]];
    i ++;
    j ++;
    
    NSString *sex = @"未知";
    NSString *hobbies = @"不晓得";
    
    BOOL result = [_db executeUpdate:@"INSERT INTO t_student (id, name, sex, hobbies) VALUES (?,?,?,?)",@(i),name,sex,hobbies];
    
    if (result) {
        NSLog(@"添加数据成功");
    } else {
        NSLog(@"添加数据失败");
    }
}

- (IBAction)modifyData:(id)sender {
    NSLog(@"修改数据");
    
    NSString *newHobbies = @"吐泡泡";
    NSString *oldHobbies = @"不晓得";
    
    BOOL result = [_db executeUpdate:@"update t_student set hobbies = ? where hobbies = ?",newHobbies,oldHobbies];
    
    if (result) {
        NSLog(@"修改成功");
    } else {
        NSLog(@"修改失败");
    }
}

- (IBAction)deleteData:(id)sender {
    NSLog(@"删除数据");
    
    
    BOOL result = [_db executeUpdateWithFormat:@"delete from t_student where sex = %@",@"未知"];
    
    if (result) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

- (IBAction)deleteTable:(id)sender {
    NSLog(@"删除表");
    
    BOOL result = [_db executeUpdate:@"drop table if exists t_student"];
    
    if (result) {
        NSLog(@"删除表成功");
    } else {
        NSLog(@"删除表失败");
    }
}

- (IBAction)queryData:(id)sender {
    NSLog(@"查询数据");
    
    FMResultSet *resultSet = [_db executeQuery:@"select * from t_student"];
//    FMResultSet *resultSet = [_db executeQuery:@"select * from t_student where  sex = ?", @"未知"];
    
    while ([resultSet next]) {
        int idNum = [resultSet intForColumn:@"id"];
        NSString *name = [resultSet objectForKeyedSubscript:@"name"];
        NSString *sex = [resultSet objectForKeyedSubscript:@"sex"];
        NSString *hobbies = [resultSet objectForKeyedSubscript:@"hobbies"];
        NSLog(@"编号：%@ 姓名：%@ 性别：%@ 爱好：%@",@(idNum),name,sex,hobbies);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
