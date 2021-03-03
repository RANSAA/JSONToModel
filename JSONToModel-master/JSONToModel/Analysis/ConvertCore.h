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
typedef void(^BlockValue)(NSString *str);

//转换模式对应了类型标记
typedef NS_ENUM(NSInteger,SupportModeType){
    SupportModeTypeYYModel = 0,         //OC-YYModel
    SupportModeTypeMJExtension,     //OC-MJExtension
    SupportModeTypeJSONModel,       //OC-JSONModel
};

//生成Model的类型
typedef NS_ENUM(NSInteger, DuplicateModeType){
    DuplicateModeStandard = 0,      //标准：如果已经解析过相同结构的Model时，不会再生成新的Model
    DuplicateModeLeast,             //最少：如果将要生成的Model是已经解析过的Model的子集时，不会再生成新的Model
    DuplicateModeAll                //全部：解析全部，即使已经解析过相同的Modl,也会生成新的Model
};

//语言类型
typedef NS_ENUM(NSInteger, CodeType){
    CodeTypeUnknown = 0,    //未标记
    CodeTypeObjective,      //objective-c语言
    CodeTypeSwift,          //swift语言
};


static NSString *kString  = @"NSString";
static NSString *kFloat   = @"CGFloat";
static NSString *kBool    = @"BOOL";
static NSString *kInt     = @"NSInteger";
static NSString *kAry     = @"NSArray";
static NSString *kDic     = @"NSDictionary";



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

/**
 Json转Model时的3种生成模式
 标准：如果已经解析过相同结构的Model时，不会再生成新的Model
 最少：如果将要生成的Model是已经解析过的Model的子集时，不会再生成新的Model
 全部：解析全部，即使已经解析过相同的Modl,也会生成新的Model
 */
- (NSArray<NSString *> *)allDuplicateMode;



#pragma mark 工具
/**
 帕斯卡命名:
 1.首字母大写，
 2."_"字符去掉,并使其后面的字母大写
 */
+ (NSString *)pascalName:(NSString *)name;

/**
 驼峰命名：
 1.首字母小写，
 2."_"字符去掉,并使其后面的字母小写
 */
+ (NSString *)humpName:(NSString *)name;


//根据value的值获取key的类型名称
+ (NSString *)attrTypeWithValue:(id)value;



/**
 获取h文件部分的后缀名称
 */
- (NSString *)hPartSuffix;

/**
 获取m文件部分的后缀名称
 */
- (NSString *)mPartSuffix;



@end




NS_ASSUME_NONNULL_END
