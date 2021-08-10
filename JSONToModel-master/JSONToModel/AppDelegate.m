//
//  AppDelegate.m
//  JSONToModel
//
//  Created by luo.h on 2018/3/14.
//  Copyright © 2018年 hl.com.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "ShowViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSLog(@"Config.shared home:%@",NSHomeDirectory());
    
    //test
    NSArray *ary1 = @[@"1",@"23"];
    NSArray *ary2 = @[@"1",@"23"];
    NSLog(@"hash :%ld,      %ld",ary1.hash, ary2.hash);
    NSLog(@"equl:%d",[ary1 containsObject:ary2]);
    
//    NSString *str0 = @"string1";
    NSString *str0 = [NSString stringWithFormat:@"stri%@",@"ng1"];
    NSString *str1 = [@"string" stringByAppendingString:@"1"];
    NSLog(@"str isEqual:%d",[str0 isEqual:str1]);
    NSLog(@"str isEqualTo:%d",[str0 isEqualTo:str1]);
    NSLog(@"str isEqualToString:%d",[str0 isEqualToString:str1]);
    
    
    NSSet *set = [NSSet setWithArray:@[@"1",@"2"]];
    NSSet *set1 = [NSSet setWithArray:@[@"1",@"2",@"3"]];
    NSLog(@"set is sub of:%d",[set isSubsetOfSet:set1]);

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
