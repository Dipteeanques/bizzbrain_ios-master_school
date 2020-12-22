//
//  VideoListresponseModel.swift
//  bizzbrains
//
//  Created by Anques Technolabs on 14/03/20.
//  Copyright © 2020 Anques Technolabs. All rights reserved.
//

import Foundation

// MARK: - VideoListresponseModel
class VideoListresponseModel: Codable {
    let success: Bool
    let data: DatavideoClass
    let message: String

    init(success: Bool, data: DatavideoClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
class DatavideoClass: Codable {
    let currentPage: Int
    let data: [DataVideo]
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

    init(currentPage: Int, data: [DataVideo], firstPageURL: String, from: Int, lastPage: Int, lastPageURL: String, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
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
class DataVideo: Codable {
    let id, maincategoryID, subcategoryID, topicID: Int
    let title, datumDescription: String
    let image: String
    let video_url: String
    let photo300X200: String
    let image_url: String
    

    enum CodingKeys: String, CodingKey {
        case id
        case maincategoryID = "maincategory_id"
        case subcategoryID = "subcategory_id"
        case topicID = "topic_id"
        case title = "title"
        case datumDescription = "description"
        case image = "image"
        case video_url = "video_url"
        case photo300X200 = "photo300x200"
        case image_url = "image_url"
    }

    init(id: Int, maincategoryID: Int, subcategoryID: Int, topicID: Int, title: String, datumDescription: String, image: String, video_url: String, photo300X200: String, image_url: String) {
        self.id = id
        self.maincategoryID = maincategoryID
        self.subcategoryID = subcategoryID
        self.topicID = topicID
        self.title = title
        self.datumDescription = datumDescription
        self.image = image
        self.video_url = video_url
        self.photo300X200 = photo300X200
        self.image_url = image_url
    }
}
