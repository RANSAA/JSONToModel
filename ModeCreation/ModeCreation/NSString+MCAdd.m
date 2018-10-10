//
//  NSString+MCAdd.m
//  ModeCreation
//
//  Created by Aka on 2018/10/10.
//  Copyright © 2018年 Laterite. All rights reserved.
//

#import "NSString+MCAdd.h"

@implementation NSString (MCAdd)

- (BOOL)isDeptNumInputShouldNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}


@end
