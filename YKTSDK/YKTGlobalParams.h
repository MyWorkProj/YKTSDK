//
//  YKTGlobalParams.h
//  yktw
//
//  Created by wangyong on 16/9/26.
//  Copyright © 2016年 yiketong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKTGlobalParams : NSObject

@property BOOL anonymous;

@property BOOL firstUse;

@property (copy, nonatomic) NSString *mobile;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *loginToken;

@property (copy, nonatomic) NSString *realMobile;

@property (copy, nonatomic) NSString *group;

@property (nonatomic) NSInteger groupId;

@property (nonatomic) NSInteger unreadMsgCount;

@property (nonatomic) NSInteger unreadLogCount;


@property BOOL netConnected;

+ (YKTGlobalParams *)sharedInstance;

@end
