//
//  ConvertCore.h
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 Json转换数据暂存
 */
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^Block)(void);

//转换模式对应了类型标记
typedef NS_ENUM(NSInteger,SupportModeType){
    SupportModeTypeYYModel = 0,         //OC-YYModel
    SupportModeTypeJSONModel = 1,       //OC-JSONModel
    SupportModeTypeMJExtension = 2,     //OC-MJExtension
};


@interface ConvertCore : NSObject
@property (nonatomic, copy) NSString *json;//存储被校验过的Josn字符串
@property (nonatomic, assign) BOOL isVildJson;//json字符串是否正确
@property (nonatomic, copy, nullable) NSDictionary *jsonDict;//json to Dict

+ (instancetype)shared;

/**
 所有支持的解析类型:
 OC-YYModel
 OC-JSONModel
 OC-MJExtension
 具体查看：OptionalSetting.json
 */
- (NSArray<NSString *> *)allSupportMode;

@end




NS_ASSUME_NONNULL_END
