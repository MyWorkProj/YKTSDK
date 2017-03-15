//
//  YKTCall.h
//  YKTSDK
//
//  Created by qianjianlei on 2017/3/15.
//  Copyright © 2017年 中联环信. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKTCall : NSObject
- (void)CallWithCalledNumber:(NSString *)called AndVirtualNumber:(NSString *)virtualNumber;
@end
