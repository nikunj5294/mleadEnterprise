//
//  Global.h
//  NewMleadsEnterprise
//
//  Created by PRIYANK on 04/05/19.
//  Copyright © 2019 com.Tri-Force.MLeadsEnterprise. All rights reserved.
//

#ifndef Global_h
#define Global_h
#endif /* Global_h */

#define DEVICE_ID                                       @"iPhoneUniqueID"
#define DEVICE_TYPE                                     @"ios"
#define DEVICE_TOKEN                                    @"DeviceToken"
#define LOGIN_USER_Detail                               @"LoginUserDetail"
#define IS_ALREADY_LOGIN                                @"isAlreadyLogin"
#define IS_SHOW_SUBSCRIPTION_DIALOG                     @"isShowSubscriptionDialog"
#define IS_LOGIN_SUCCESSFUL                             @"isLoginSuccessful"
#define LOGIN_ID                                        @"UserLoginID"
#define isAppLaunchedFirstTime                          @"isAppLaunchedFirstTime"
#define kIsLoginSuccessful                              @"isLoginSuccessful"
#define LOGIN_NOTIFICATION                              @"checkAuth"

#define REGISTRATION_NOTIFICATION                       @"doRegistration"

#define USER_TYPE_FOR_APP                               @"E"
#define BUSINESS_USER_TYPE                              @"S"

//LOCAL SERVER
//#define WEBSERVICE_URL                                  @"http://192.168.1.51/mleads9.6/MLeads9.7.19/"
//#define MY_DASHBOARD_URL                                @"https://www.myleadssite.com/dashboardmobile.php?userId="
//#define     ReportURL                                   @"http://192.168.1.51/mleads9.6/reports/"


//LIVE Server
#define WEBSERVICE_URL                                   @"https://www.myleadssite.com/MLeads9.7.22/"
#define MY_DASHBOARD_URL                                 @"https://www.myleadssite.com/dashboardmobile.php?userId="
#define ReportURL                                        @"https://www.myleadssite.com/reports/"



#define GET_COUNTRY_FROM_IP_ADDRESS                     @"http://api.codehelper.io/ips/"

#define LOGIN_API_URL                                    @"getLogin.php"
#define REGISTRATION_API_URL                             @"registerFreeTrialEnterpriseUser.php"
#define LOGINDEVICERESPONSE_API_URL                      @"getRegisterDevice.php"
#define FORGOT_PASSWORD_API_URL                          @"getForgotPassword.php"
#define GET_FORGOT_PASSWORD_EMAIL                        @"getForgotPasswordEmail.php"
#define RESET_PASSWORD_API_URL                           @"getChangePassword.php"
#define GET_USER_DETAIL                                  @"getUserDetail.php"
#define GET_ADD_PUSHNOTIFICATION                         @"getAddPushNotification.php"
#define LOGOUT_API_URL                                   @"getUnRegisterDevice.php"

#define GET_ADD_TEAM_MEMBER_API_URL                      @"registerFeeTrialAddTeamMember.php"
#define GET_ADD_TEAM_MEMBER_LIST                         @"getAddTeamMemberList.php"
#define UPDATE_USER_API_URL                              @"updateUser.php"
#define SUBMIT_REQUEST_FOR_DEMO_API                      @"addRequestDemo.php"
#define DELETE_TEAM_MEMBER_API_URL                       @"deleteTeamMember.php"
#define TRANSFER_TEAM_MEMBER_API_URL                     @"transferTeamMember.php"

#define GET_EVENT_COUNT                                  @"getEventCount.php"

#define ADD_MEETING_API_URL                              @"getAddMeeting.php"
#define GET_MEETING_LIST_API_URL                         @"getMeetingList.php"
#define GET_TASK_LIST_API_URL                            @"getTaskList.php"
#define ADD_TASK_API_URL                                 @"getAddTask.php"
#define GET_EVENTLIST_ENTERPISE_WITHIN_URL               @"getEventListwithin_Enterprise.php"
#define GET_EVENTLIST_ENTERPISE_URL                      @"getEventList_Enterprise_iphone.php"
#define ADD_LEAD_POST_URL                                @"getAddLeadPost.php"
#define DELETE_LEAD_API_URL                              @"getDeleteLead.php"
#define GET_ALL_EVENT_API_URL                            @"getEventList.php"
#define GET_REGISTER_EVENTS_WITHIN_URL                   @"getRegisteredEvents.php"
#define ADD_EVENT_API_URL                                @"getAddEvent.php"
#define EDIT_EVENT_API_KEY                               @"updateEvent.php"
#define DELETE_EVENT_BY_ID_API_URL                       @"getDeleteEvent.php"
//
#define Get_GroupDetails_By_Id_URL                       @"getLeadGroupDetail.php"
#define Add_LeadGroup_API_URL                            @"getAddLeadGroup.php"
#define GET_ALL_GROUPLIST_URL                            @"getLeadGroupListWithin.php"

#define UploadProfileAndWhiteLogo                        @"getUploadLogo.php"


//
#define GET_LEADLIST_ENTERPISE_URL                       @"getLeadList_Enterprise_new.php"

#define GET_SCHEDULED_TASKS_URL                          @"getTaskListLastTwoWeekEnterprice.php"
#define GET_SCHEDULED_MEETINGS_URL                       @"getMeetingListLastTwoWeekEnterprice.php"

#define GET_TASK_DETAIL_API_URL                          @"getTaskDetail.php"
#define UPDATE_TASK_API_URL                              @"updateTask.php"

#define GET_MEETING_DETAIL_API_URL                       @"getMeetingDetail.php"

#define GET_PipeLine_Sales_Report                       @"pipelinesales.php?userId="
#define GET_Sales_Report                                @"salesreport.php?userId="
#define Sales_Cycle_Report_API_URL                      @"salesCycleReport.php"
#define GET_LeadByLead_Qualifire_Report                 @"leadsreport.php?eventId="

#define Get_EmailTamplate_API                           @"getEmailTemplate.php"

#define GET_EventList_For_User_Api                      @"getUserEventWiseLeadList.php"

#define CSV_NEW_LINE_INDICATOR                          @"\n"

#define GET_VideoProfile_Link_URL                       @"getVideoLinks.php"

#define GET_ExportAbility_API_URL                       @"updateExportAbility.php"

#define GET_EMAIL_STATISTICS_URL                        @"getEmailstatistics.php"
//TESTING PERPOSE...
#define GET_EVENTLIST_ENTERPISE_URL_TESTING             @"getEventListwithin_Enterprise_android.php"
