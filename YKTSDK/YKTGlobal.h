//
//  YKTGlobal.h
//  yktw
//
//  Created by wangyong on 16/9/26.
//  Copyright © 2016年 yiketong. All rights reserved.
//

#ifndef YKTGlobal_h
#define YKTGlobal_h

//App default colro
#define YKT_SYS_APP_BLUE  [UIColor colorWithRed:17.0/255.0 green:184.0/255.0 blue:246.0/255.0 alpha:1.0]

//notification name
#define YKT_NOTIFICATION_WIZARD_DISMISSED @"com.1ketong.notification.wizard.dismissed"
#define YKT_NOTIFICATION_LOGIN_DISMISSED @"com.1ketong.notification.login.dismissed"
#define YKT_NOTIFICATION_USER_SIGNOUT @"com.1ketong.notification.user.signout"
#define YKT_NOTIFICATION_muiBack @"com.1ketong.notification.back4ReloadAddrbookData"

//升级服务相关
#define YKT_SYS_ID_APP_VERSION @"com.1ketong.yktw.version"
#define YKT_SYS_ID_BUILD_VER @"com.1ketong.yktw.build"
#define kAppStoreID @"1148014169"
#define API_APPSTORE_VERSION @"https://itunes.apple.com/lookup?id=1148014169"


#define YKT_ALERT_BTN_OK @"确认"
//first use
#define YKT_APP_FIRST_USED @"com.1ketong.app.firstUsed"
#define YKT_APP_LOGIN_MOBILE @"com.1ketong.app.workmobile"
#define YKT_APP_LOGIN_LASTMOBILE @"com.1ketong.app.lastmobile"
#define YKT_APP_LOGIN_PWD @"com.1ketong.app.loginPwd"

//#define YKT_API_SERVER_PREFIX @"http://124.160.63.237:81/ykt-work-server/"
#define YKT_API_SERVER_PREFIX @"http://app.1ketong.com:81/ykt-work-server/"
#define YKT_API_RETURN_SUCCESS 1
//user
#define API_USER_LOGIN @"login.htm"
#define API_USER_CHANGEPWD @"updatePwd.htm"

//short message
#define API_MESSAGE_LIST @"sms/list.htm"
#define API_MESSAGE_DIALOG @"sms/detail.htm"
#define API_MESSAGE_RELATION @"sms/relation.htm"

//call
#define API_CALL_LIST @"cdr/list.htm"   //话单列表查询接口
#define API_CALL_DETAIL @"cdr/detail.htm" //通话详情记录
#define API_CALL_RELATION @"call/relation.htm"  //呼叫关系绑定接口

//visit
#define API_VISIT_ADD @"visit/add.htm"   //新建拜访
#define API_VISIT_LIST @"visit/list.htm" //查询拜访
#define API_VISIT_DETAIL @"visit/detail.htm"  //拜访详情，仅返回日志
#define API_VISIT_ADDLOG @"visit/addLog.htm"    //新建拜访日志
#define API_VISIT_DELLOG @"visit/delLog.htm"    //删除拜访日志
#define API_VISIT_UPLOADMP3 @"visit/uploadAudio.htm"    //上传mp3日志文件

//addrbook
#define API_ADDRBOOK_UPDATE @"contact/list.htm"
#define API_ADDRBOOK_DETAIL @"contact/detail.htm"   //通讯录详情接口
#define API_ADDRBOOK_ADD @"contact/add.htm"         // 添加接口
#define YKT_APP_ADDRBOOK_LASTUPDATETIME0 @"com.1ketong.app.addrbook.lastUpdateTime0"
#define YKT_APP_ADDRBOOK_LASTUPDATETIME1 @"com.1ketong.app.addrbook.lastUpdateTime1"

#define API_UNREAD_COUNT @"unRead/count.htm"    //unread count

typedef enum {
    kMessageDirect=1,
    kMessageAddressBook,
    kMessageCallRecord,
    kMessageMessageRecord
}MessageBindingType;

//  1.直接呼叫   2.通讯录外呼     3.通话记录外呼    4.短信记录外呼
typedef enum {
    kCallDirect=1,
    kCallAddressBook,
    kCallCallRecord,
    kCallMessageRecord
}CallBindingType;

#endif /* YKTGlobal_h */
