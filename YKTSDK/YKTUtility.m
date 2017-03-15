//
//  YKTUtility.m
//  yktw
//
//  Created by wangyong on 16/9/26.
//  Copyright © 2016年 yiketong. All rights reserved.
//

#import "YKTUtility.h"
#import "YKTLoadingView.h"
//#import "AppDelegate.h"

@implementation YKTUtility

+ (void)saveCacheData:(id)obj withKey:(NSString *)keyName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:obj forKey:keyName];
    [userDefaults synchronize];
    
}

+ (id)loadCacheData:(NSString *)keyName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:keyName];
}

+ (void)clearCacheData:(NSString *)keyName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:keyName];
    [userDefaults synchronize];
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format timeZone:(NSTimeZone *)zone
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (zone)
        [formatter setTimeZone:zone];
    else
        [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFrom:(NSString *)strDate withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:strDate];
}

+ (NSString *)getContactDay:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSUInteger countNowDay = [cal ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:now];
    NSUInteger countDateDay = [cal ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    if (countNowDay == countDateDay) return  @"今天"; //同一天
    
    NSUInteger countNowWeek = [cal ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:now];
    NSUInteger countDateWeek = [cal ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *component = [cal components:unitFlags fromDate:date];
    if (countNowWeek == countDateWeek) { //同一天
        NSArray *weekday = [NSArray arrayWithObjects:@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
        return  [weekday objectAtIndex:([component weekday]-1)];
    }
    return [NSString stringWithFormat:@"%ld/%ld/%ld",[component year] - 2000, [component month], [component day]];
}

+(NSString *)getContactDayFormatMonthDay:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSUInteger countNowDay = [cal ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:now];
    NSUInteger countDateDay = [cal ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
    if (countNowDay == countDateDay) return  @"今天"; //同一天
    
    NSUInteger countNowWeek = [cal ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:now];
    NSUInteger countDateWeek = [cal ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:date];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateComponents *component = [cal components:unitFlags fromDate:date];
    if (countNowWeek == countDateWeek) { //同一天
        NSArray *weekday = [NSArray arrayWithObjects:@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
        return  [weekday objectAtIndex:([component weekday]-1)];
    }
    return [NSString stringWithFormat:@"%ld月%ld日",[component month], [component day]];
}

+ (NSString *)getContactTime:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *component = [cal components:unitFlags fromDate:date];
    
    return [NSString stringWithFormat:@"%ld:%02ld",[component hour], (long)[component minute]];
}

+ (BOOL)isLocationServiceEnabled {
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)    {
        return YES;
    }
    return NO;
}


+ (NSString *) getNonNullString:(NSString *)string {
    if (string == nil || string == NULL) {
        return @"";
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return @"";
    }
    return string;
}

/*
 *网络加载
 */
static YKTLoadingView *sharedLoadingView = nil;

+ (void)showLoadingView {
    if (sharedLoadingView == nil) {
        sharedLoadingView = [[YKTLoadingView alloc] init];
    }
    [sharedLoadingView showView];
}

+ (void)dismissLoadingView {
    if (sharedLoadingView == nil) {
        sharedLoadingView = [[YKTLoadingView alloc] init];
    }
    [sharedLoadingView dismissView];
    
}

/*
 *是否包含Emoji表情
 */
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (void)queryUnread {
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate queryUnread];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     
     * 手机号码
     
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     * 联通：130,131,132,152,155,156,185,186
     
     * 电信：133,1349,153,180,189
     
     */
    
    NSString * MOBILE = @"^1(3[0-9]|4[7]|5[0-35-9]|7[6-8]|8[0-9])\\d{8}$";
    
    /**
     
     * 中国移动：China Mobile
     
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     */
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     
     * 中国联通：China Unicom
     
     * 130,131,132,152,155,156,185,186
     
     */
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     
     * 中国电信：China Telecom
     
     * 133,1349,153,180,189
     
     */
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /**
     
     *大陆地区固话及小灵通
     
     * 区号：010,020,021,022,023,024,025,027,028,029
     
     *号码：七位或八位
     
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
        
    {
        
        return YES;
        
    }
    
    else
        
    {
        
        return NO;
        
    }
    
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)getNonNullString:(NSString *)string WithoutString:(NSString *)withoutString{
    string= [string stringByReplacingOccurrencesOfString:withoutString withString:@""];
    
    if(![self getNonNullString:string]){
        string = @"";
    }
    if ([string isEqualToString:withoutString]) {
        string = @"";
    }
    
//    NSString *regex = @"^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if (![predicate evaluateWithObject:email]) {
//        [LCAlertView showWithTitle:nil message:@"请输入有效的邮件地址" buttonTitle:@"确认"];
//        return NO;
//    }
//    return YES;
//    
    return string;
}
@end
