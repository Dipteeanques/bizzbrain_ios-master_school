//
//  subCategetResponsModel.swift
//  bizzbrains
//
//  Created by Kalu's mac on 24/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - SubcategoryGetResponsModel
class SubcategoryGetResponsModel: Codable {
    let success: Bool
    let data: DataSubCatClass
    let message: String

    init(success: Bool, data: DataSubCatClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
class DataSubCatClass: Codable {
    let currentPage: Int
    let data: [DatumsubCat]
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

    init(currentPage: Int, data: [DatumsubCat], firstPageURL: String, from: Int, lastPage: Int, lastPageURL: String, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
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
class DatumsubCat: Codable {
    let id: Int
    let title: String
    let image: String
    let type: String
    let maincategoryID: Int
    let datumDescription: String
    let topicCount: Int
    let photo300X200: String

    enum CodingKeys: String, CodingKey {
        case id, title, image, type
        case maincategoryID = "maincategory_id"
        case datumDescription = "description"
        case topicCount = "topic_count"
        case photo300X200 = "photo300x200"
    }

    init(id: Int, title: String, image: String, type: String, maincategoryID: Int, datumDescription: String, topicCount: Int, photo300X200: String) {
        self.id = id
        self.title = title
        self.image = image
        self.type = type
        self.maincategoryID = maincategoryID
        self.datumDescription = datumDescription
        self.topicCount = topicCount
        self.photo300X200 = photo300X200
    }
}
