//
//  YKTNetworkUtility.m
//  yktw
//
//  Created by wangyong on 2016/10/9.
//  Copyright © 2016年 yiketong. All rights reserved.
//

#import "YKTNetworkUtility.h"
#import "YKTGlobal.h"
#import "YKTGlobalParams.h"
#import "YKTUtility.h"

static const NSInteger REQUEST_TIMEOUT = 60 ;

@implementation YKTNetworkUtility
+(instancetype)sharedInstance
{
    static id _instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)getRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail {
    NSMutableString *strM = [[NSMutableString alloc] init];
    
    [paramaters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        // 服务器接收参数的 key 值.
        NSString *paramaterKey = key;
        
        // 参数内容
        NSString *paramaterValue = obj;
        
        // appendFormat :可变字符串直接拼接的方法!
        [strM appendFormat:@"%@=%@&",paramaterKey,paramaterValue];
    }];
    
    urlString = [NSString stringWithFormat:@"%@?%@",urlString,strM];
    
    // 截取字符串的方法!
    urlString = [urlString substringToIndex:urlString.length - 1];
    
    NSLog(@"urlString:%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    // 2. 发送网络请求.
    // completionHandler: 说明网络请求完成!
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        // 网络请求成功:
        if (data && !error) {
            // JSON 解析.查看 data 是否是 JSON 数据.
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (!obj) { // 如果 obj 能够解析,说明就是 JSON
                obj = data;
            }
            // 成功回调
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(obj,response);
                }
            });
            
        }else {//失败
            if (fail) { // 失败回调
                fail(error);
            }
        }
        
    }] resume];
}
- (void)postRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail {
    // 1. 创建请求.参数拼接.遍历参数字典,一一取出参数
    NSString *wholeUrl = [NSString stringWithFormat:@"%@%@",YKT_API_SERVER_PREFIX, urlString];
    NSURL *url = [NSURL URLWithString:wholeUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:REQUEST_TIMEOUT];
    // 1.设置请求方法:
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"1001" forHTTPHeaderField:@"reqId"];
    [request addValue:@"1.0" forHTTPHeaderField:@"reqVersion"];
    if ([YKTGlobalParams sharedInstance].loginToken) {
        [request addValue:[YKTGlobalParams sharedInstance].loginToken forHTTPHeaderField:@"loginToken"];
    }
    // 2.设置请求体
    
    // 设置提交的数据
    if (paramaters) {
        NSError *error;
        //NSData *postData = [NSJSONSerialization dataWithJSONObject:queryParam options:NSJSONWritingPrettyPrinted error:&error];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:paramaters options:0 error:&error];
        if (!error) {
            request.HTTPBody = postData;
            NSLog(@"【%@】 request:%@",urlString,[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
        }
    }
    // 2. 发送网络请求.
    // completionHandler: 说明网络请求完成!
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"【%@】 response:%@",urlString,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        // 网络请求成功:
        if (data && !error) {
            // JSON 解析.查看 data 是否是 JSON 数据.
            NSError *jsonError;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) { // 如果 obj 能够解析,说明就是 JSON
                YKTApiResult *ret = [[YKTApiResult alloc] init];
                ret.result = -100;
                ret.message = jsonError.description;
                success(ret, response);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{ // 成功回调
                if (success) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    YKTApiResult *ret = [[YKTApiResult alloc] init];
                    ret.result = [[dic objectForKey:@"result"] integerValue];
                    if (ret.result == 9000) {
                        YKTGlobalParams *gParams = [YKTGlobalParams sharedInstance];
                        gParams.anonymous = YES;
                        gParams.loginToken = nil;
//                        [YKTUtility clearCacheData:YKT_APP_LOGIN_MOBILE];
//                        [YKTUtility clearCacheData:YKT_APP_LOGIN_PWD];
                        [[NSNotificationCenter defaultCenter] postNotificationName:YKT_NOTIFICATION_USER_SIGNOUT object:nil];
                        return;
                    }
                    ret.message = [dic objectForKey:@"message"];
                    ret.value = dic;
                    success(ret, response);
                }
            });
        }else {//失败回调
            if (fail) {
                fail(error);
            }
        }
        
    }] resume];
}

- (void)syncPostRequestWithUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail {
    // 1. 创建请求.参数拼接.遍历参数字典,一一取出参数
    NSString *wholeUrl = [NSString stringWithFormat:@"%@%@",YKT_API_SERVER_PREFIX, urlString];
    NSURL *url = [NSURL URLWithString:wholeUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:REQUEST_TIMEOUT];
    // 1.设置请求方法:
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"1001" forHTTPHeaderField:@"reqId"];
    [request addValue:@"1.0" forHTTPHeaderField:@"reqVersion"];
    if ([YKTGlobalParams sharedInstance].loginToken) {
        if (!paramaters) {
            paramaters = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        [paramaters setObject:[YKTGlobalParams sharedInstance].loginToken forKey:@"token"];
    }
    // 2.设置请求体
    
    // 设置提交的数据
    if (paramaters) {
        NSError *error;
        //NSData *postData = [NSJSONSerialization dataWithJSONObject:queryParam options:NSJSONWritingPrettyPrinted error:&error];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:paramaters options:0 error:&error];
        if (!error) {
            request.HTTPBody = postData;
            NSLog(@"request:%@?%@",wholeUrl, [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
        }
    }
    // 2. 发送网络请求.
    // completionHandler: 说明网络请求完成!
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        // 网络请求成功:
        if (data && !error) {
            // JSON 解析.查看 data 是否是 JSON 数据.
            NSError *jsonError;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) { // 如果 obj 能够解析,说明就是 JSON
                YKTApiResult *ret = [[YKTApiResult alloc] init];
                ret.result = jsonError.code;
                ret.message = jsonError.description;
                success(ret, response);
                return;
            }
            dispatch_sync(dispatch_get_main_queue(), ^{ // 成功回调
                if (success) {
                    YKTApiResult *ret = [[YKTApiResult alloc] init];
                    NSDictionary *dic = (NSDictionary *)obj;
                    ret.result = [[dic objectForKey:@"result"] integerValue];
                    ret.message = [dic objectForKey:@"message"];
                    ret.value = dic;
                    if (ret.result == 9000) {
                        YKTGlobalParams *gParams = [YKTGlobalParams sharedInstance];
                        gParams.anonymous = YES;
                        gParams.loginToken = nil;
//                        [YKTUtility clearCacheData:YKT_APP_LOGIN_MOBILE];
//                        [YKTUtility clearCacheData:YKT_APP_LOGIN_PWD];
                        [[NSNotificationCenter defaultCenter] postNotificationName:YKT_NOTIFICATION_USER_SIGNOUT object:nil];
                        return;
                    }
                    success(ret, response);
                }
            });
        }else {//失败回调
            if (fail) {
                fail(error);
            }
        }
        
    }] resume];
}

- (void)postRequestDirectUrl:(NSString *)urlString paramaters:(NSMutableDictionary *)paramaters successBlock:(SuccessBlock)success FailBlock:(failBlock)fail {
    // 1. 创建请求.参数拼接.遍历参数字典,一一取出参数
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:REQUEST_TIMEOUT];
    // 1.设置请求方法:
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    // 2.设置请求体
    
    // 设置提交的数据
    if (paramaters) {
        NSError *error;
        //NSData *postData = [NSJSONSerialization dataWithJSONObject:queryParam options:NSJSONWritingPrettyPrinted error:&error];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:paramaters options:0 error:&error];
        if (!error) {
            request.HTTPBody = postData;
            NSLog(@"【%@】 request:%@",urlString, [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
        }
    }
    // 2. 发送网络请求.
    // completionHandler: 说明网络请求完成!
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"【%@】 response:%@",urlString,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        // 网络请求成功:
        if (data && !error) {
            // JSON 解析.查看 data 是否是 JSON 数据.
            NSError *jsonError;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) { // 如果 obj 能够解析,说明就是 JSON
                YKTApiResult *ret = [[YKTApiResult alloc] init];
                ret.result = -100;
                ret.message = jsonError.description;
                success(ret, response);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{ // 成功回调
                if (success) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    YKTApiResult *ret = [[YKTApiResult alloc] init];
                    ret.result = [[dic objectForKey:@"result"] integerValue];
                    ret.message = [dic objectForKey:@"message"];
                    ret.value = dic;
                    success(ret, response);
                }
            });
        }else {//失败回调
            if (fail) {
                fail(error);
            }
        }
        
    }] resume];
}


@end
