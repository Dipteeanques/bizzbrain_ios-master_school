//
//  StudentGetResponseModel.swift
//  bizzbrains
//
//  Created by Kalu's mac on 30/01/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - FilterSearchStudentGetResponseModel
class FilterSearchStudentGetResponseModel: Codable {
    let success: Bool
    let data: [FilterSearchDatum]
    let message: String

    init(success: Bool, data: [FilterSearchDatum], message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - FilterSearchDatum
class FilterSearchDatum: Codable {
    let id: Int
    let name: String
    let schoolLogo: String
    let profile: String
    let standard, section: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case schoolLogo = "school_logo"
        case profile, standard, section
    }

    init(id: Int, name: String, schoolLogo: String, profile: String, standard: String, section: String) {
        self.id = id
        self.name = name
        self.schoolLogo = schoolLogo
        self.profile = profile
        self.standard = standard
        self.section = section
    }
}
