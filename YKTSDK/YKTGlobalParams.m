//
//  YKTGlobalParams.m
//  yktw
//
//  Created by wangyong on 16/9/26.
//  Copyright © 2016年 yiketong. All rights reserved.
//
#import "YKTGlobal.h"
#import "YKTGlobalParams.h"

static YKTGlobalParams *single;

@implementation YKTGlobalParams

+ (YKTGlobalParams *)sharedInstance
{
    if(single == nil){
        single = [[super allocWithZone:nil] init];
        single.anonymous = YES;
        single.firstUse = NO;
        single.loginToken = YKT_LOGINTOKEN;
        single.group = nil;
        single.groupId = 0;
        single.unreadLogCount = 0;
        single.unreadMsgCount = 0;
    }
    return single;
}

+ (id)alloc
{
    return nil;
}

+ (id)new
{
    return [self alloc];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self alloc];
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self copyWithZone:zone];
}

@end
