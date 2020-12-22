//
//  DocumnetListResponsModel.swift
//  bizzbrains
//
//  Created by Kalu's mac on 21/02/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//


import Foundation

// MARK: - DocumentListResponsModel
class DocListResponsModel: Codable {
    let success: Bool
    let data: DataDocumentClass
    let message: String

    init(success: Bool, data: DataDocumentClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
class DataDocumentClass: Codable {
    let currentPage: Int
    let data: [DatumDocument]
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

    init(currentPage: Int, data: [DatumDocument], firstPageURL: String, from: Int, lastPage: Int, lastPageURL: String, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
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
class DatumDocument: Codable {
    let id, maincategoryID, subcategoryID, topicID: Int
    let title, datumDescription: String
    let image: String
    let pdf: String
    let photo300X200: String

    enum CodingKeys: String, CodingKey {
        case id
        case maincategoryID = "maincategory_id"
        case subcategoryID = "subcategory_id"
        case topicID = "topic_id"
        case title
        case datumDescription = "description"
        case image, pdf
        case photo300X200 = "photo300x200"
    }

    init(id: Int, maincategoryID: Int, subcategoryID: Int, topicID: Int, title: String, datumDescription: String, image: String, pdf: String, photo300X200: String) {
        self.id = id
        self.maincategoryID = maincategoryID
        self.subcategoryID = subcategoryID
        self.topicID = topicID
        self.title = title
        self.datumDescription = datumDescription
        self.image = image
        self.pdf = pdf
        self.photo300X200 = photo300X200
    }
}
