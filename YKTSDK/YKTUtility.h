//
//  YKTUtility.h
//  yktw
//
//  Created by wangyong on 16/9/26.
//  Copyright © 2016年 yiketong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface YKTUtility : NSObject
/*
 *缓存数据读取与设置
 */
+ (void)saveCacheData:(id)obj withKey:(NSString *)keyName;

+ (id)loadCacheData:(NSString *)keyName;

+ (void)clearCacheData:(NSString *)keyName;


/*
 *获取通话、短信时的日期时间信息
 */
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format timeZone:(NSTimeZone *)zone;
+ (NSDate *)dateFrom:(NSString *)strDate withFormat:(NSString *)format;

+ (NSString *)getContactDay:(NSDate *)date;
+ (NSString *)getContactDayFormatMonthDay:(NSDate *)date;
+ (NSString *)getContactTime:(NSDate *)date;

/*
 *是否打开定位功能
 */
+ (BOOL)isLocationServiceEnabled;

/*
 *获取非Nil字符串
 */
+ (NSString *) getNonNullString:(NSString *)string;

/*
 *网络加载
 */
+ (void)showLoadingView;
+ (void)dismissLoadingView;

/*
 *是否包含Emoji表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;


+ (void)queryUnread;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*
 *是否为非Nil字符串
 */
+ (BOOL) isBlankString:(NSString *)string;
/*
*获取不为withoutString的非空字符串并把withoutString替换为“”
*/
+ (NSString *)getNonNullString:(NSString *)string WithoutString:(NSString *)withoutString;
@end
