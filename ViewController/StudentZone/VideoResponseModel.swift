// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let videoResponsModel = try? newJSONDecoder().decode(VideoResponsModel.self, from: jsonData)

import Foundation

// MARK: - VideoResponsModel
public struct VideoResponsModel: Codable {
    public let success: Bool
    public let data: DataClassVideo
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataClassVideo, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataClassVideo: Codable {
    public let currentPage: Int
    public let data: [DatumVideo]
    public let firstPageURL: String
    public let from: Int
    public let lastPage: Int
    public let lastPageURL: String
    public let nextPageURL: String
    public let path: String
    public let perPage: Int
    public let prevPageURL: String
    public let to: Int
    public let total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data = "data"
        case firstPageURL = "first_page_url"
        case from = "from"
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path = "path"
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to = "to"
        case total = "total"
    }

    public init(currentPage: Int, data: [DatumVideo], firstPageURL: String, from: Int, lastPage: Int, lastPageURL: String, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
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
public struct DatumVideo: Codable {
    public let id: Int
    public let datumDescription: String
    public let name: String
    public let subject: String
    public let teacher: String
    public let date: String
    public let teacherNoteFiles: [String]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case datumDescription = "description"
        case name = "name"
        case subject = "subject"
        case teacher = "teacher"
        case date = "date"
        case teacherNoteFiles = "teacher_note_files"
    }

    public init(id: Int, datumDescription: String, name: String, subject: String, teacher: String, date: String, teacherNoteFiles: [String]) {
        self.id = id
        self.datumDescription = datumDescription
        self.name = name
        self.subject = subject
        self.teacher = teacher
        self.date = date
        self.teacherNoteFiles = teacherNoteFiles
    }
}
