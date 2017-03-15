//
//  YKTApiResult.h
//  yktw
//
//  Created by wangyong on 2016/10/9.
//  Copyright © 2016年 yiketong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKTApiResult : NSObject

@property (nonatomic) NSInteger result;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) id value;

@end
