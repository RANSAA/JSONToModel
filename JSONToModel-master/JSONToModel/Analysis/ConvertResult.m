//
//  ConvertResult.m
//  JSONToModel
//
//  Created by PC on 2021/2/23.
//  Copyright © 2021 hl.com.cn. All rights reserved.
//

#import "ConvertResult.h"
#import "Config.h"

@interface ConvertResult ()
@property(nonatomic, strong) NSMutableArray *aryModelNames;
@property(nonatomic, strong) NSMutableArray *tmpAryH;//转存所有model @interface部分
@property(nonatomic, strong) NSMutableArray *tmpAryM;//转存所有model @implementation部分


@property (nonatomic, strong) NSMutableArray *aryJsonModelNames;//所有模型名称ary
@property (nonatomic, strong) NSMutableArray *aryJsonPorpertys;//所有属性+类型ary; <NSSet *>

@property(nonatomic, strong) NSMutableDictionary *allImportClassDic;//用于存储所有自定义解析Class
@property(nonatomic, assign) NSInteger convertIndex;


@end

@implementation ConvertResult
+ (instancetype)shared
{
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self.class alloc] init];
    });
    return obj;
}

- (instancetype)init
{
    if (self = [super init]) {
        _aryManualHandKey = @[].mutableCopy;
        _tmpAryM = @[].mutableCopy;
        _tmpAryH = @[].mutableCopy;
        _aryModelNames = @[].mutableCopy;

        _aryJsonModelNames = @[].mutableCopy;
        _aryJsonPorpertys = @[].mutableCopy;
        
        _allImportClassDic = @{}.mutableCopy;
    }
    return self;
}

/** 重置存储环境 */
- (void)resetEnv
{
    [_aryManualHandKey removeAllObjects];
    [_tmpAryH removeAllObjects];
    [_tmpAryM removeAllObjects];
    [_aryModelNames removeAllObjects];
    
    [_aryJsonModelNames removeAllObjects];
    [_aryJsonPorpertys removeAllObjects];
    
    [_allImportClassDic removeAllObjects];
}

/** 设置当前最外层是第几次循环解析 */
- (void)setConvertIndex:(NSInteger)index
{
    _convertIndex = index;
}

- (NSMutableSet *)curImportClassAry
{
    NSString *key = [NSString stringWithFormat:@"%ld",_convertIndex];
    NSMutableSet *ary = _allImportClassDic[key];
    if (!ary) {
        ary = [NSMutableSet setWithCapacity:0];
        _allImportClassDic[key] = ary;
    }
    return ary;
}

/**  获取显示文字 */
- (NSString *)getShowString
{
    NSMutableString *mark = [[NSMutableString alloc] init];
    if (Config.shared.isMultipleFile) {
        for (NSInteger i=0; i<_tmpAryH.count; i++) {
            NSString *h = _tmpAryH[i];
            NSString *m = _tmpAryM[i];
            [mark appendFormat:@"%@\n\n%@\n\n\n",h,m];
        }
    }else{
        for (NSString *node in _tmpAryH) {
            [mark appendFormat:@"%@\n",node];
        }
        [mark appendString:@"\n\n\n"];
        for (NSString *node in _tmpAryM) {
            [mark appendFormat:@"%@\n",node];
        }
    }
    return mark;
}


/**
 添加.h部分进行暂存
 hStr:
 modelName:对应模型名称
 */
- (void)addHString:(NSString *)hStr name:(NSString *)modelName
{
    [_tmpAryH insertObject:hStr atIndex:0];
    [_aryModelNames insertObject:modelName atIndex:0];
}



/**
 向最后一个model的.h部分追加特定字符串
 */
- (void)addSpecificStringToLastString
{
    if (Config.shared.codeType ==  CodeTypeObjective) {
        if (!Config.shared.isMultipleFile && _tmpAryH.count > 0) {
            NSString *str = [_tmpAryH lastObject];
            str = [NSString stringWithFormat:@"%@NS_ASSUME_NONNULL_END",str];
            _tmpAryH[_tmpAryH.count-1] = str;
        }
    }
}


/**
 添加.m部分进行暂存
 mStr:
 modelName:对应模型名称
 */
- (void)addMString:(NSString *)mStr
{
    [_tmpAryM insertObject:mStr atIndex:0];
}


/**
 获取需要保存文件的信息
 */
- (NSDictionary *)getModelFileInfo
{
    NSMutableDictionary *dict = @{}.mutableCopy;
    if (Config.shared.isMultipleFile) {
        for (NSInteger i=0; i<_tmpAryH.count; i++) {
            NSString *hString = _tmpAryH[i];
            NSString *mString = _tmpAryM[i];
            NSString *h = [NSString stringWithFormat:@"%@.%@",_aryModelNames[i],[ConvertCore.shared hPartSuffix]];
            NSString *m = [NSString stringWithFormat:@"%@.%@",_aryModelNames[i],[ConvertCore.shared mPartSuffix]];
            if (hString.length>10) {
                [dict addEntriesFromDictionary:@{h:hString}];
            }
            if (mString.length>10) {
                [dict addEntriesFromDictionary:@{m:mString}];
            }
        }
    }else{
        if (_aryModelNames.count>0) {
            NSMutableString *hString = [[NSMutableString alloc] init];
            NSMutableString *mString = [[NSMutableString alloc] init];
            for (NSString *node in _tmpAryH) {
                [hString appendFormat:@"%@\n",node];
            }
            for (NSString *node in _tmpAryM) {
                [mString appendFormat:@"%@\n",node];
            }
            NSString *h = [NSString stringWithFormat:@"%@.%@",_aryModelNames[0],[ConvertCore.shared hPartSuffix]];
            NSString *m = [NSString stringWithFormat:@"%@.%@",_aryModelNames[0],[ConvertCore.shared mPartSuffix]];
            if (hString.length>10) {
                [dict addEntriesFromDictionary:@{h:hString}];
            }
            if (mString.length>10) {
                [dict addEntriesFromDictionary:@{m:mString}];
            }
        }
    }
    return dict;
}


- (void)saveAs
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
//    openPanel.directoryURL = NSHomeDirectory();//起始目录为Home
    openPanel.allowsOtherFileTypes = false;
    openPanel.treatsFilePackagesAsDirectories = false;
    openPanel.canChooseFiles = false;
    openPanel.canChooseDirectories = true;
    openPanel.canCreateDirectories = true;
    openPanel.prompt = @"Save As";
    
    [openPanel beginSheetModalForWindow:NSApplication.sharedApplication.keyWindow completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            [self writeToPath:openPanel.URL.path];
        }
    }];

}

- (void)writeToPath:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSDictionary *dic = [self getModelFileInfo];
    for (NSString *fileName in dic.allKeys) {
        NSString *fileStr = dic[fileName];
        NSString *savePath = [path stringByAppendingPathComponent:fileName];
        NSLog(@"savePath:%@",savePath);
        NSData *data = [fileStr dataUsingEncoding:NSUTF8StringEncoding];
        [manager createFileAtPath:savePath contents:data attributes:nil];
    }
}








#pragma mark 处理查询书否有相同的json字段并且具有相同属性结构

/** 根据节点获取Set
 该节点数据为属性名+属性类型
 */
- (NSSet *)getNodeSetWithNodeDic:(NSDictionary *)nodeDic
{
    NSMutableArray *aryPorpertys = @[].mutableCopy;
    NSArray *allKeys = [nodeDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in allKeys) {
        id value = nodeDic[key];
        NSString *type = [ConvertCore attrTypeWithValue:value];
        [aryPorpertys addObject:[NSString stringWithFormat:@"%@+%@",key,type]];
    }
    NSSet *nodeSet = [NSSet setWithArray:aryPorpertys];
    return nodeSet;
}


/**
 添加对应的模型名称与原始dic
 */
- (void)addModelName:(NSString *)modelName rootDic:(NSDictionary *)rootDict
{
    [_aryJsonModelNames addObject:modelName];
    NSSet *set = [self getNodeSetWithNodeDic:rootDict];
    [_aryJsonPorpertys addObject:set];
}

/**
 根据json节点数据查询对应的modelName
 */
- (nullable NSString *)quearyModelNameWithNode:(NSDictionary *)nodeDic
{
    NSSet *quearySet = [self getNodeSetWithNodeDic:nodeDic];
    BOOL isSet = NO;
    NSInteger index = 0;
    for (NSSet *node in _aryJsonPorpertys) {
        if ([quearySet isSubsetOfSet:node]) {
            isSet = YES;
            break;
        }
        index++;
    }
    if (isSet) {
        return _aryJsonModelNames[index];;
    }
    return nil;
}



/** 检查该json节点是否有，父亲json结构解析集合存在*/
- (BOOL)isSubsetOfJsonNode:(NSDictionary *)nodeDic
{
    NSSet *quearySet = [self getNodeSetWithNodeDic:nodeDic];
    BOOL isSet = NO;
    for (NSSet *node in _aryJsonPorpertys) {
        if ([quearySet isSubsetOfSet:node]) {
            isSet = YES;
            break;
        }
    }
    return isSet;
}

/** 检查该json节点是否有，相同json结构解析集合存在*/
- (BOOL)isMemberToJsonNode:(NSDictionary *)nodeDic
{
    NSSet *quearySet = [self getNodeSetWithNodeDic:nodeDic];
    BOOL isSet = NO;
    for (NSSet *node in _aryJsonPorpertys) {
        if ([quearySet isEqualToSet:node]) {
            isSet = YES;
            break;
        }
    }
    return isSet;
}

@end


