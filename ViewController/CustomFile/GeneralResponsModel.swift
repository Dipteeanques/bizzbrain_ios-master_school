//
//  GeneralResponsModel.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 11/09/19.
//  Copyright © 2019 Anques Technolabs. All rights reserved.
//

import Foundation


struct StateResponseModel: Decodable {
    let success: Bool
    let data: [String]
    let message: String
}

struct UploadParameterMode {
    let parameterName: String
    let parameterData: Data
    let fileName: String
    let fileMime: String
}

//MARK: - CategoriesResponsModel
struct CategoriesResponsModel: Decodable {
    let success: Bool
    let data: FreePaidrespons
    let message: String
}

struct FreePaidrespons: Decodable {
    let Free: [AllcategoryResponse]
    let Paid: [AllcategoryResponse]
}

struct AllcategoryResponse: Decodable {
    let id: Int
    let title: String
    let image: String
    let description: String
    let type: String
    let photo300x300: String
}

//MARK: - BannerResponsModel
struct BannerResponsModel: Decodable {
    let success: Bool
    let data: [String]
    let message: String
}

//MARK: - MainCategoriesResponsModel
struct MainCategoriesResponsModel: Decodable {
    let success: Bool
    let data: [String]
    let message: String
}

struct mainCategories: Decodable {
    let id: Int
    let maincategory_id: Int
    let user_id: Int
    let expiry_date: String
}

//MARK: - MainCategoriesSearchResponsModel
struct MainCategoriesSearchResponsModel: Decodable {
    let success: Bool
    let data: [MainCatSearch]
    let message: String
}

struct MainCatSearch: Decodable {
    let id: Int
    let title: String
    let type: String
    let image: String
    let description: String
    let category_type: String
}

//MARK: - AddCategoryResponsModel
struct AddCategoryResponsModel: Decodable,Encodable {
    let success: Bool
    let data: [addcategory]
    let message: String
}

struct addcategory: Decodable,Encodable {
    let id: Int
    let title: String
    let description: String
    let image: String
    let type: String
    var month_labal: String
    var price: String
    let month_list: [String]
    let photo300x300: String
}

//MARK: - subcategoryResponsModel
struct subcategoryResponsModel: Decodable {
    let success: Bool
    let data: [subCategory]
    let message: String
}

struct subCategory: Decodable {
    let id: Int
    let maincategory_id: Int
    let title: String
    let image: String
    let description: String
    let is_topic: Int
    let photo300x300: String
}

//MARK: - topicResponseModel
struct topicResponseModel: Decodable {
    let success: Bool
    let data: [topicModel]
    let message: String
}

struct topicModel: Decodable {
    let id: Int
    let maincategory_id: Int
    let subcategory_id: Int
    let title: String
    let description: String
    let is_test: Int
    let is_document: Int
    let is_video: Int
}


//MARK: - documentlistresponsmodel
struct documentlistresponsmodel: Codable {
    let success: Bool
    let data: documentlistpagination
    let message: String
}

struct documentlistpagination: Codable {
    let current_page: Int
    let data: [documentList]
    let first_page_url: String
    let from: Int
    let last_page: Int
    let last_page_url: String
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct documentList: Codable {
    let id: Int
    let maincategory_id: Int
    let subcategory_id: Int
    let topic_id: Int
    let title: String
    let description: String
    let image: String
    let pdf: String
    let photo300x300: String
    let fullPdf: String?
}



//MARK: - TestListResponsmodel
struct TestListResponsmodel: Decodable {
    let success: Bool
    let data: testlistpagination
    let message: String
}

struct testlistpagination: Decodable {
    let current_page: Int
    let data: [testModelset]
    let first_page_url: String
    let from: Int
    let last_page: Int
    let last_page_url: String
    let next_page_url: String
    let path: String
    let per_page: Int
    let prev_page_url: String
    let to: Int
    let total: Int
}

struct testModelset: Decodable {
    let id: Int
    let title: String
    let description: String
    let image: String
    let is_exam_questions: Int
    let photo300x200: String
    let is_done: Int
}



//MARK: - profileUpdateresponsModel
struct profileUpdateresponsModel: Decodable {
    let success: Bool
    let data: updateprofile
    let message: String
}

struct updateprofile: Decodable {
    let name: String
    let school_name: String
    let college_name: String
}

//MARK: - Htmlresponsmodel
struct Htmlresponsmodel: Decodable {
    let success: Bool
    let data: htmldata
    let message: String
}

struct htmldata: Decodable {
    let id: Int
    let title: String
    let name: String
    let content: String
}

//MARK: - monthPriceresponsModel
struct monthPriceresponsModel: Decodable,Encodable {
    let success: Bool
    let data: monthpricerespon
    let message: String
}

struct monthpricerespon: Decodable,Encodable {
    let title: String
    let type: String
    let price: String
}

//MARK: - forgotChangepwd
struct forgotChangepwd: Decodable {
    let success: Bool
    let data: forgotchangpassword
    let message: String
}
struct forgotchangpassword: Decodable {
    let username: String
}


//MARK: - AnswerQuestionresponsmodel
struct AnswerQuestionresponsmodel: Decodable {
    let success: Bool
    let data: [answerQuestion]
    let message: String
}

struct answerQuestion: Decodable {
    let id: Int
    let test_id: Int
    let questions: String
    let answer: String
    let option0: String
    let option1: String
    let option2: String
    let option3: String
    let option4: String
    let questions_text: String
    let questions_img: String
    let questions_custom: String
    let questions_type: String
    let option_type: String
    let option_custom: [String]
}

//MARK: - AnswerQuestionResultsRespons
struct AnswerQuestionResultsRespons: Decodable {
    let success: Bool
    let data: ResultsMarks
    let message: String
}

struct ResultsMarks: Decodable {
    let test_id: String
    let user_id: Int
    let total_question: String
    let right_answer: String
    let total_marks: String
    let updated_at: String
    let created_at: String
    let id: Int
}

//MARK: - couponsCheckResponsModel
struct couponsCheckResponsModel: Decodable {
    let success: Bool
    let data: checkCoupon
    let message: String
}

struct checkCoupon: Decodable {
    let sub_total: String
    let discount_amount: String
    let total_amount: String
}


//MARK: - paymentPricezeroresponsmodel
struct paymentPricezeroresponsmodel: Decodable,Encodable {
    let success: Bool
    let data: [String]
    let message: String
}

//MARK: - MysuscribeResponsModel
struct MysuscribeResponsModel: Decodable {
    let success: Bool
    let data: [SubscribeResponse]
    let message: String
}

struct SubscribeResponse: Decodable {
    let id: Int
    let title: String
    let type: String
    let image: String
    let description: String
    let photo300x200: String
    let photo300x300: String
}

//MARK: SubjectResponsModdel

struct SubjectResponsModdel: Decodable {
    let success: Bool
    let data: [subjectModel]
    let message: String
    
}

struct subjectModel: Decodable {
    let id: Int
    let name: String
}



//MARK: FeesDetailResponsModdel
struct RootClass: Codable {

    let success: Bool
    let data: FeesData
    let message: String

}

struct FeesData: Codable {

    let id: Int
    let total_fees: Int
    let remain_fees: Int
    let fees_types: [FeesTypes]
    let fees_dues: [FeesDues]

}

struct FeesTypes: Codable {

    let id: Int
    let fees_structure_id: Int
    let title: String
    let fees: Int

}

struct FeesDues: Codable {

    let id: Int
    let fees_structure_id: Int
    let due_date: String
    let pay_fees: Int
    let title: String

}


//MARK: FeesPaymentHistoryResponsModdel
struct PaymentHistoryRoot: Codable {

    let success: Bool
    let data: [HistoryData]
    let message: String

}

struct HistoryData: Codable {

    let id: Int
    let school_id: Int
    let academic_year_id: Int
    let s_standard_id: Int
    let s_class_room_id: Int
    let invoice_number: String
    let student_id: Int
    let remark: String
    let total_fees: Int
    let receive_by: Int
    let invoice_url: String
    let payment_response: String
    let created_at: String
    let updated_at: String
    let invoice_full_url: String

}
