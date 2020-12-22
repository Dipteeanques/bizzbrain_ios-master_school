//
//  EventResponModel.swift
//  bizzbrains
//
//  Created by Kalu's mac on 09/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - EventResponsModel
class EventResponsModel: Codable {
    let success: Bool
    let data: DataClassEvent
    let message: String

    init(success: Bool, data: DataClassEvent, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
class DataClassEvent: Codable {
    let currentPage: Int
    let data: [DatumEvent]
    let firstPageURL: String
    let from, lastPage: Int
    let lastPageURL: String
    let nextPageURL: String
    let path: String
    let perPage: Int
    let prevPageURL: String
    let to, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }

    init(currentPage: Int, data: [DatumEvent], firstPageURL: String, from: Int, lastPage: Int, lastPageURL: String, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
        self.currentPage = currentPage
        self.data = data
        self.firstPageURL = firstPageURL
        self.from = from
        self.lastPage = lastPage
        self.lastPageURL = lastPageURL
        self.nextPageURL = nextPageURL
        self.path = path
        self.perPage = perPage
        self.prevPageURL = prevPageURL
        self.to = to
        self.total = total
    }
}

// MARK: - Datum
class DatumEvent: Codable {
    let id: Int
    let name: String
    let image: String
    let dateTime: String
    let datumEventDescription: String

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case dateTime = "date_time"
        case datumEventDescription = "description"
    }

    init(id: Int, name: String, image: String, dateTime: String, datumEventDescription: String) {
        self.id = id
        self.name = name
        self.image = image
        self.dateTime = dateTime
        self.datumEventDescription = datumEventDescription
    }
}
