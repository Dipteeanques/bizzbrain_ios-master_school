//
//  Constant.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import Foundation

let Domain           =      "https://www.bizzbrains.com/api/v1/"// "http://bizzbrains.com/api/v1/"//"https://bizzbrains.com/api/v1/"
//let Domain         =       "http://192.168.0.30/elearning/api/v2/"

let Xapi             =       "jwZryAdcrffggf867DnjhjhfRvsfhjs5667"

let LOGIN            =       Domain + "login"
let REGISTER         =       Domain + "register"
let CHANGEPASSWORD   =       Domain + "ChangePassword"
let FORGOT_PASSWORD  =       Domain + "forgot_password"
let LOGIN_WITH_OTP   =       Domain + "login_with_otp"
let NEW_PASSWORD     =       Domain + "new_password"
let OTP_VERIFY       =       Domain + "verify_otp"
let LOGIN_FACEBOOK   =       Domain + "loginwithfacebook"
let REGISTER_VALIDATOR =     Domain + "register_validator"


let PROFILE          =       Domain + "Profile"
let PAGESLINK        =       Domain + "pages"
let HISTORY          =       Domain + "History"
let RESULT           =       Domain + "HistoryResult"
let SUBSCRIPTION     =       Domain + "Subscription"
let RESULTSQ_A       =       Domain + "Result"


let CARTSUMMARY      =       Domain + "CarSummary"
let COUPONSLIST      =       Domain + "couponsList"
let CHECK_COUPONS    =       Domain + "check_coupons_list"

let STATE            =       Domain + "state"
let CITY             =       Domain + "city"
let CATEGORIES       =       Domain + "FreePaid"
let SUBCATEGORY      =       Domain + "SubCategory"
let TOPIC            =       Domain + "Topic"
let DOCUMENT         =       Domain + "Document"
let TEST             =       Domain + "Test"
let QUSTIONANSWER    =       Domain + "QustionAnswer"

let GETUSERSUBSCRIPTION  =   Domain + "get_user_subscription"

//MARK: Dashboard
let BANNERS          =       Domain + "banners"
let SEARCH           =       Domain + "search"
let ADDCATEGORY      =       Domain + "AddCategory"
let MAINCATEGORY     =       Domain + "MainCategory"

//let DASHBOARDS       =       Domain + "dashboards?device_type=ios"
let DASHBOARDS       =       Domain + "dashboards"
let CATEGORY_DETAILS =       Domain + "new_main_category_details"
let VERSIONCATDETAILS =      Domain + "new_main_category_details"

let PAYMENT           =      Domain + "Payment"
let GENERATE_CHECKSUM =      Domain + "generate_checksum"

let CallSetting       =      Domain + "settings"
let AddSubCategory    =      Domain + "AddSubCategory"

let GET_PRICE_CATEGORY   =   Domain + "get_price_category"

let GetSubCategory =         Domain + "GetSubCategory"
let GetMainCategory     =    Domain + "GetMainCategory"

let GETMAINCATEGORYDETAILS = Domain + "GetMainCategoryDetails"

let PARENT_LOGIN_WITH_OTP  =  Domain + "parents_login_with_otp"

let PARENT_VERIFY_OTP      = Domain + "parents_verify_otp"

let STUDENT_GET            =  Domain + "students_get"
let ATTENDANCE             =  Domain + "attendances"
let ASSIGNMENT             =  Domain + "assignments"
let OLDERASSIGNMENT      = Domain + "old_assignments"

let HELP_DESK              =  Domain + "help_desk"
let STUDENTS_INFO          =  Domain + "students_info"

let CHANGEPROFILE          = Domain + "changeProfile"

let EVENT                  =  Domain + "event"
let EXAM_RESULTS           =  Domain + "exam_results"
let EXAM_RESULT_DETAIL     =  Domain + "exam_result_detail"
let TIME_TABLES            =  Domain + "time_tables"
let school_information     =  Domain + "school_information"
let transport_details      =  Domain + "transport_details"
let push_notification_list =  Domain + "push_notification_list"
let upcoming_exam          =  Domain + "upcoming_exam"
let upcoming_exam_detail   =  Domain + "upcoming_exam_detail"

let update_device_token    =  Domain + "update_device_token"

let videos                 = Domain + "videos"
let exam_videos =  Domain + "exam/videos"

let getNotestudent = Domain + "exam/notes?notes_type=notes"
let getExamPaperNote = Domain + "exam/notes?notes_type=exam_paper"

let get_subject = Domain + "get_subject"
let instructor = Domain + "instructor"
let GetInstructorMainCategory = Domain + "GetInstructorMainCategory"

let get_fessdetail = Domain + "get_fees_details"
let get_fees_payment_history = Domain + "get_fees_payment_history"


func generateCustomerID() -> String
{
    let randomNo = Int(arc4random_uniform(29999) + 1)
    return "CUST\(randomNo)"
}

let rupee = "\u{20B9}"


//MARK: - User Default
let loggdenUser = UserDefaults.standard

let CARTVALUE = "CARTVALUE"
let CARTCOUNT = "CARTCOUNT"

let ISLOGIN           = "ISLOGIN"
let PARENT_ISLOGIN    = "PARENT_ISLOGIN"
let STUDENT_ISLOGIN   = "STUDENT_ISLOGIN"



let COLLEGE_NAME      = "COLLEGE_NAME"
let SCHOOL_NAME       = "SCHOOL_NAME"
let USERNAME          = "USERNAME"
let ROLE_ID           = "ROLE_ID"
let PHONE_NUMBER      = "PHONE_NUMBER"
let NAME              = "NAME"
let EMAIL             = "EMAIL"
let TOKEN             = "TOKEN"
let FCM               = "FCM"
let DOB               = "DOB"
let GENDER            = "GENDER"
let STATELog          = "STATE"
let CITYLog           = "CITY"
let PROFILE_IMAGE     = "profile"
let SCHOOL_LOGO       = "school_logo"
let STUDENT_ID        = "STUDENT_ID"
let USER_ID           = "USER_ID"

let all_Ids = "all_Ids"


let PROFILEMAIN = "profile1"
let CLASS = "class"
let STANDARD = "standard"

