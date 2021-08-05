//
//  RootModel.h
//
//  JSONToModel  See: https://github.com/RANSAA/JSONToModel
//
//  Created by Mac on 2021-08-05.
//  Copyright © 2021 芮淼一线 All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN 

@class Data;
@class IconData;
@class RoomList;
@interface RootModel : NSObject

@property (nonatomic, strong) NSArray *data;//Data 
@property (nonatomic, assign) NSInteger error;

@end 


@interface Data : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger count_ios;
@property (nonatomic, assign) NSInteger has_corner_icon;
@property (nonatomic, strong) NSString *icon_url;
@property (nonatomic, strong) NSString *push_nearby;
@property (nonatomic, assign) NSInteger push_vertical_screen;
@property (nonatomic, strong) NSArray *room_list;//RoomList 
@property (nonatomic, strong) NSString *small_icon_url;
@property (nonatomic, strong) NSString *tag_id;
@property (nonatomic, strong) NSString *tag_name;

@end 


@interface RoomList : NSObject

@property (nonatomic, strong) NSString *anchor_city;
@property (nonatomic, strong) NSString *avatar_mid;
@property (nonatomic, strong) NSString *avatar_small;
@property (nonatomic, assign) NSInteger cate_id;
@property (nonatomic, assign) NSInteger child_id;
@property (nonatomic, strong) NSString *game_name;
@property (nonatomic, assign) NSInteger hn;
@property (nonatomic, strong) IconData *icon_data;
@property (nonatomic, assign) NSInteger isVertical;
@property (nonatomic, strong) NSString *jumpUrl;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, assign) NSInteger nrt;
@property (nonatomic, assign) NSInteger online;
@property (nonatomic, strong) NSString *owner_uid;
@property (nonatomic, assign) NSInteger rmf1;
@property (nonatomic, assign) NSInteger rmf2;
@property (nonatomic, assign) NSInteger rmf3;
@property (nonatomic, assign) NSInteger rmf4;
@property (nonatomic, assign) NSInteger rmf5;
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *room_name;
@property (nonatomic, strong) NSString *room_src;
@property (nonatomic, strong) NSString *show_status;
@property (nonatomic, strong) NSString *show_time;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *vertical_src;

@end 


@interface IconData : NSObject

@property (nonatomic, assign) NSInteger icon_height;
@property (nonatomic, strong) NSString *icon_url;
@property (nonatomic, assign) NSInteger icon_width;
@property (nonatomic, assign) NSInteger status;

@end 

NS_ASSUME_NONNULL_END
