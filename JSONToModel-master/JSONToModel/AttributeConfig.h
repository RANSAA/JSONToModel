//
//  AttributeConfig.h
//  JSONToModel
//
//  Created by PC on 2021/2/21.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//
/**
 Model属性配置
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttributeConfig : NSObject
@property(nonatomic, assign) BOOL isCompareKey;//是否对生成的model属性进行排序，默认YES

+ (instancetype)shared;
@end

NS_ASSUME_NONNULL_END
