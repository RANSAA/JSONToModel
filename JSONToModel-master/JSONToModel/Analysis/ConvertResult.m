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
        _aryCustomModelNames = @[].mutableCopy;
        _tmpAryM = @[].mutableCopy;
        _tmpAryH = @[].mutableCopy;
        _aryModelNames = @[].mutableCopy;
    }
    return self;
}

/** 重置存储环境 */
- (void)resetEnv
{
    [_aryManualHandKey removeAllObjects];
    [_aryCustomModelNames removeAllObjects];
    [_tmpAryH removeAllObjects];
    [_tmpAryM removeAllObjects];
    [_aryModelNames removeAllObjects];
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
            NSString *h = [NSString stringWithFormat:@"%@.h",_aryModelNames[i]];
            NSString *m = [NSString stringWithFormat:@"%@.m",_aryModelNames[i]];
            [dict addEntriesFromDictionary:@{h:hString,
                                             m:mString
            }];
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
            NSString *h = [NSString stringWithFormat:@"%@.h",_aryModelNames[0]];
            NSString *m = [NSString stringWithFormat:@"%@.m",_aryModelNames[0]];
            [dict addEntriesFromDictionary:@{h:hString,
                                             m:mString
            }];
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


@end
