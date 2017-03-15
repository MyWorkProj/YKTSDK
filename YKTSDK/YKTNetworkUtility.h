//
//  YKTNetworkUtility.h
//  yktw
//
//  Created by wangyong on 2016/10/9.
//  Copyright © 2016年 yiketong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKTApiResult.h"

typedef void(^SuccessBlock)(YKTApiResult *ret , NSURLResponse *response);
typedef void(^failBlock)(NSError *error);

@interface YKTNetworkUtility : NSObject

+ (instancetype)sharedInstance;

- (void)getRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;
- (void)postRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;
- (void)syncPostRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;
- (void)postRequestDirectUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail;

@end
