//
//  ViewController.m
//  ModeCreation
//
//  Created by Aka on 2018/10/8.
//  Copyright © 2018年 Laterite. All rights reserved.
//

#import "ViewController.h"
#import <Cocoa/Cocoa.h>
#import <Masonry.h>
#import "NSDictionary+MCAdd.h"
#import "NSString+MCAdd.h"

static NSString *const kInheritingNSObject = @":NSObject";

@interface ViewController ()

@property (weak) IBOutlet NSTextField *prefixTF;
@property (weak) IBOutlet NSTextField *currentTf;
@property (weak) IBOutlet NSTextField *suffixTF;
@property (weak) IBOutlet NSPopUpButton *choicePopUpBtn;
@property (weak) IBOutlet NSButton *generateBtn;
@property (weak) IBOutlet NSTextView *jsonInputTextView;
@property (weak) IBOutlet NSButton *generateFileBtn;
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;

@property (nonatomic, copy) NSString *prefixString;
@property (nonatomic, copy) NSString *currentString;
@property (nonatomic, copy) NSString *suffixString;
@property (nonatomic, copy) NSString *jsonInputString;
@property (nonatomic, copy) NSString *outputContentString;
@property (nonatomic, copy) NSString *outputPropertyString;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *headerFileName;
@property (nonatomic, copy) NSString *impFileName;

@property (nonatomic, strong) NSMutableArray *mModelDicts;
@property (nonatomic, strong) NSMutableDictionary *mModelDict;
@property (nonatomic, strong) NSMutableArray *mModelHasFinsheds; // 这个先暂时慢点用


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mModelDict = @{}.mutableCopy;
    _mModelDicts = @[].mutableCopy;
    
//     default value
    _prefixTF.stringValue = @"DL";
    _currentTf.stringValue = @"Test";
    _suffixTF.stringValue = @"Model";
    
    [self onViewInit];
}

- (void)viewDidAppear {
    [super viewDidAppear];
}

- (void)onViewInit {
    _outputTextView.textColor = [NSColor orangeColor];
}

- (void)onGetJsonModelWithJson:(NSString *)inputJson {
    NSDictionary *dict =[NSDictionary dictionaryWithJSON:inputJson];
    NSArray<NSString *> *allKeys = dict.allKeys;
    
    if (!dict || allKeys.count <=0) {
        NSLog(@"input json error");
        return;
    }
    [self onCreatePropertyJsonWithKeys:allKeys inputDict:dict];
}

- (void)onCreatePropertyJsonWithKeys:(NSArray<NSString *> *)keys inputDict:(NSDictionary *)inputDict {
    NSMutableString *mPropertyString = @"".mutableCopy;
    for (NSString *keyString in keys) {
        NSString *currentKeyProperty;
        id value = [inputDict objectForKey:keyString];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSLog(@"内部是一个字典");
            NSString *subClassName = [NSString stringWithFormat:@"%@%@%@",_prefixString,keyString,_suffixString];
            currentKeyProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;\n",subClassName,keyString];
            [_mModelDict setObject:value forKey:keyString];
            [_mModelDicts addObject:subClassName];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray *values = (NSArray *)value;
            id firstObj = values.firstObject;
            NSString *type;
            if ([firstObj isKindOfClass:[NSDate class]]) {
                type = @"NSDate";
            }
            else if ([firstObj isKindOfClass:[NSNumber class]]) {
                type = @"NSNumber";
            }
            else if ([firstObj isKindOfClass:[NSString class]]) {
                type = @"NSString";
            }
            else if ([firstObj isKindOfClass:[NSDictionary class]]){
                NSString *subClassName = [NSString stringWithFormat:@"%@%@%@",_prefixString,keyString,_suffixString];
                type = subClassName;
                [_mModelDict setObject:firstObj forKey:keyString];
                [_mModelDicts addObject:subClassName];
            }
            else {
//                 暂时没有想到什么要处理的
            }
            if (type.length >0) {
                currentKeyProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray<%@> *%@s;\n",type,keyString];
            }
            else {
                currentKeyProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@s;\n",keyString];
            }
        }
        else if ([value isKindOfClass:[NSDate class]]) {
              currentKeyProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDate *%@;\n",keyString];
        }
        else if ([value isKindOfClass:[NSString class]]){
            NSString *valueString = (NSString *)value;
            BOOL isNumber = [valueString isDeptNumInputShouldNumber:valueString];
            if (isNumber) {
                currentKeyProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSNumber *%@;\n",keyString];
            }
            else {
                currentKeyProperty = [NSString stringWithFormat:@"@property (nonatomic, copy)   NSString *%@;\n",keyString];
            }
        }
        else {
        }
        if (currentKeyProperty.length >0) {
            [mPropertyString appendString:currentKeyProperty];
        }

    }
    _outputContentString = mPropertyString;
    NSString *currentClassPropertiesString = [NSString stringWithFormat:@"@interface %@%@%@ %@ \n\n%@ \n@end \n",_prefixString, _currentString, _suffixString, kInheritingNSObject, _outputContentString];
    
    if (_outputPropertyString.length <=0) {
        _outputPropertyString =currentClassPropertiesString;
    }
    else {
        _outputPropertyString = [NSString stringWithFormat:@"%@ \n\n%@",currentClassPropertiesString,_outputPropertyString];
    }
    
    if (_mModelDict.count >0) {
        NSArray *allkeys = _mModelDict.allKeys;
        NSString *currentKey = allkeys.firstObject;
        _currentString = currentKey;
        NSDictionary *currentDict = [_mModelDict objectForKey:currentKey];
        NSArray *currentAllKeys = currentDict.allKeys;
        [_mModelDict removeObjectForKey:currentKey];
        [self onCreatePropertyJsonWithKeys:currentAllKeys inputDict:currentDict];
    }
}


- (void)onGetModelNameInfo {
    if (_jsonInputTextView.string.length <=0){
        NSLog(@"请输入json数据");
        return;
    }
     _jsonInputString = _jsonInputTextView.string;
    
    if (_prefixTF.stringValue.length >0) {
        _prefixString = _prefixTF.stringValue;
    }
    else {
        _prefixString = @"";
    }
    
    if (_currentTf.stringValue.length >0) {
        _currentString = _currentTf.stringValue;
    }
    else {
        _currentString = @"";
    }
    
    if (_suffixTF.stringValue.length >0) {
        _suffixString = _suffixTF.stringValue;
    }
    else {
        _suffixString = @"";
    }
    
    _fileName = [NSString stringWithFormat:@"%@%@%@", _prefixString, _currentString, _suffixString];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (void)showInOutputView {
    _outputTextView.string = _outputPropertyString;
}

#pragma mark -- action

- (IBAction)onGeneratefileAction:(id)sender {
    NSLog(@"生成对应的类模型文件");
    NSString *documentPath = [NSString stringWithFormat:@"%@/ModelCreation",NSHomeDirectory()];
  
    NSError *error = nil;
    BOOL documentFlag = [[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:&error];
    NSLog(@"document flag :%hhd",documentFlag);
    if (error) {
        NSLog(@"create directory error");
    }
    
    NSString *headerFile = [NSString stringWithFormat:@"%@.h",_fileName];
    NSString *headerFilePath = [documentPath stringByAppendingPathComponent:headerFile];
    NSData *headerData = [_outputPropertyString dataUsingEncoding:NSUTF8StringEncoding];
    BOOL headerFileFlag = [[NSFileManager defaultManager] createFileAtPath:headerFilePath contents:headerData attributes:nil];
    NSLog(@"header file falg :%d",headerFileFlag);

    NSString *impFile = [NSString stringWithFormat:@"%@.m",_fileName];
    NSString *impFileString = [self createImpFileString];
    NSData *impData = [impFileString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *impFilePath = [documentPath stringByAppendingPathComponent:impFile];
    BOOL impFileFlag = [[NSFileManager defaultManager] createFileAtPath:impFilePath contents:impData attributes:nil];
    NSLog(@"imp file falg :%d",impFileFlag);
    
    NSLog(@"file :%@",documentPath);
}
- (NSString *)createImpFileString {
    NSMutableString *mImpContentString = @"".mutableCopy;
    NSString *importString = [NSString stringWithFormat:@"#import \"\%@\" \n\n",_fileName];
    [mImpContentString appendString:importString];
    
    for (NSString *className in _mModelDicts) {
        NSString *currentClassString = [NSString stringWithFormat:@"@implementation %@ \n\n\n\n@end\n\n",className];
        [mImpContentString appendString:currentClassString];
    }
    return mImpContentString;
}

- (IBAction)onGenerateModelAction:(id)sender {
    NSLog(@"生成文件夹名字和获取模型");
    [self onGetModelNameInfo];
    [_mModelDicts addObject:_fileName];
    
    [self onGetJsonModelWithJson:_jsonInputString];
    [self showInOutputView];
}

@end
