//
//  YKTCall.m
//  YKTSDK
//
//  Created by qianjianlei on 2017/3/15.
//  Copyright © 2017年 中联环信. All rights reserved.
//

#import "YKTCall.h"
#import "YKTGlobal.h"
#import "YKTApiResult.h"
#import "Reachability.h"
#import "YKTGlobalParams.h"
#import "YKTNetworkUtility.h"

static NSString *rtn;
@interface YKTCall (){
    YKTGlobalParams *gParams;
}
@end

@implementation YKTCall


+ (id)sharedInstance{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (void)CallWithCalledNumber:(NSString *)called AndVirtualNumber:(NSString *)virtualNumber{
    [self checkNetworkState];
    
    if (gParams.netConnected) {    // 判断网络状况  有网
        [self CalWithInNet:called AndEntityId:virtualNumber];
    }else{
        [self CallWithOutNet:called AndEntityId:virtualNumber];
    }
    
}

//有网直接呼叫号码
- (void)CalWithInNet:(NSString *) called AndEntityId:(NSString *)virtualNumber{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [params setValue:@"1" forKey:@"type"];
    [params setValue:called forKey:@"entityId"];
    
    [[YKTNetworkUtility sharedInstance] postRequestWithUrl:API_CALL_RELATION paramaters:params successBlock:^(YKTApiResult *ret, NSURLResponse *response) {
        if (ret.result ==1) {
            rtn = virtualNumber;
            [self call:rtn];
        }else{
            rtn = @"-1";
        }
    } FailBlock:^(NSError *error) {
        rtn = @"-1";
        NSLog(@"request fail.err:%@", error.description);
    }];
}

//无网直接呼叫号码
- (void)CallWithOutNet:(NSString *) called AndEntityId:(NSString *)virtualNumber{
    NSMutableString *callNum = [[NSMutableString alloc] init];
    [callNum appendFormat:@"%@,%@",virtualNumber,called];
    rtn = callNum;
    [self call:rtn];
}

- (void)call:(NSString *)tel{
    UIApplication *myApp = [UIApplication sharedApplication];
    NSString *theCall = [NSString stringWithFormat:@"tel://%@",tel];
    NSLog(@"tel:%@",tel);
    [myApp openURL:[NSURL URLWithString:theCall]];
}

#pragma mark - network state
- (void)networkStateChanged {
    [self checkNetworkState];
}

- (void)checkNetworkState {
    //分别检测wifi和手机网络
    Reachability *internet = [Reachability reachabilityForInternetConnection];
    
    gParams = [YKTGlobalParams sharedInstance];
    if ([internet currentReachabilityStatus] == NotReachable) {
        gParams.netConnected = NO;
    }else{
        gParams.netConnected = YES;
    }
}

@end
