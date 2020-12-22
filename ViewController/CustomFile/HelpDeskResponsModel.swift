//
//  HelpDeskResponsModel.swift
//  bizzbrains
//
//  Created by Kalu's mac on 02/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - HelpDeskRespons
class HelpDeskRespons: Codable {
    let success: Bool
    let data: DataHelpClass
    let message: String

    init(success: Bool, data: DataHelpClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
class DataHelpClass: Codable {
    let id: Int
    let name, contanctNumber, address, emailID: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case contanctNumber = "contanct_number"
        case address
        case emailID = "email_id"
    }

    init(id: Int, name: String, contanctNumber: String, address: String, emailID: String) {
        self.id = id
        self.name = name
        self.contanctNumber = contanctNumber
        self.address = address
        self.emailID = emailID
    }
}
