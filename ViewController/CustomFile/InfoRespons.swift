//
//  InfoRespons.swift
//  bizzbrains
//
//  Created by Kalu's mac on 02/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//



import Foundation

// MARK: - InfoModelRespons
class InfoModelRespons: Codable {
    let success: Bool
    let data: DataInfoClass
    let message: String

    init(success: Bool, data: DataInfoClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
class DataInfoClass: Codable {
    let name, email, phoneNumber, schoolName: String
    let schoolContanctNumber, schoolAddress, schoolEmail, section: String
    let fee: Int
    let hodName, hodPhoneNumber, teacherName, teacherPhoneNumber: String

    enum CodingKeys: String, CodingKey {
        case name, email
        case phoneNumber = "phone_number"
        case schoolName = "school_name"
        case schoolContanctNumber = "school_contanct_number"
        case schoolAddress = "school_address"
        case schoolEmail = "school_email"
        case section, fee
        case hodName = "hod_name"
        case hodPhoneNumber = "hod_phone_number"
        case teacherName = "teacher_name"
        case teacherPhoneNumber = "teacher_phone_number"
    }

    init(name: String, email: String, phoneNumber: String, schoolName: String, schoolContanctNumber: String, schoolAddress: String, schoolEmail: String, section: String, fee: Int, hodName: String, hodPhoneNumber: String, teacherName: String, teacherPhoneNumber: String) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.schoolName = schoolName
        self.schoolContanctNumber = schoolContanctNumber
        self.schoolAddress = schoolAddress
        self.schoolEmail = schoolEmail
        self.section = section
        self.fee = fee
        self.hodName = hodName
        self.hodPhoneNumber = hodPhoneNumber
        self.teacherName = teacherName
        self.teacherPhoneNumber = teacherPhoneNumber
    }
}
