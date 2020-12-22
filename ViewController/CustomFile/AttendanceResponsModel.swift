//
//  AttendanceResponsModel.swift
//  bizzbrains
//
//  Created by Kalu's mac on 02/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - AttendanceModel
class AttendanceModel: Codable {
    let success: Bool
    let data: [Datum]
    let message: String

    init(success: Bool, data: [Datum], message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - Datum
class Datum: Codable {
    let date, status: String

    init(date: String, status: String) {
        self.date = date
        self.status = status
    }
}
