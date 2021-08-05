//
//  RootModel.m
//
//  JSONToModel  See: https://github.com/RANSAA/JSONToModel
//
//  Created by Mac on 2021-08-05.
//  Copyright © 2021 芮淼一线 All rights reserved.
//

#import "RootModel.h" 

@implementation RootModel 

//返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : Data.class};
}

@end 


@implementation Data 

//返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"room_list" : RoomList.class};
}

@end 


@implementation RoomList 

@end 


@implementation IconData 

@end 


