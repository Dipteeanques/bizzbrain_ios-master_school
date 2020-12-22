// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let assignmentResponsModel = try? newJSONDecoder().decode(AssignmentResponsModel.self, from: jsonData)

import Foundation

// MARK: - AssignmentResponsModel
public struct AssignmentResponsModel: Codable {
    public let success: Bool
    public let data: DataClass
    public let message: String

    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }

    public init(success: Bool, data: DataClass, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - DataClass
public struct DataClass: Codable {
    public let currentPage: Int
    public let data: [DatumAssign]
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

    public init(currentPage: Int, data: [DatumAssign], firstPageURL: String, from: Int, lastPage: Int, lastPageURL: String, nextPageURL: String, path: String, perPage: Int, prevPageURL: String, to: Int, total: Int) {
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
public struct DatumAssign: Codable {
    public let id: Int
    public let name: String
    public let lastDate: String
    public let datumDescription: String
    public let sTeacherID: Int
    public let assignmentFile: [AssignmentFile]
    public let teacher: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case lastDate = "last_date"
        case datumDescription = "description"
        case sTeacherID = "s_teacher_id"
        case assignmentFile = "assignment_file"
        case teacher = "teacher"
    }

    public init(id: Int, name: String, lastDate: String, datumDescription: String, sTeacherID: Int, assignmentFile: [AssignmentFile], teacher: String) {
        self.id = id
        self.name = name
        self.lastDate = lastDate
        self.datumDescription = datumDescription
        self.sTeacherID = sTeacherID
        self.assignmentFile = assignmentFile
        self.teacher = teacher
    }
}

// MARK: - AssignmentFile
public struct AssignmentFile: Codable {
    public let id: Int
    public let file: String
    public let sAssignmentID: Int
    public let fileName: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case file = "file"
        case sAssignmentID = "s_assignment_id"
        case fileName = "file_name"
    }

    public init(id: Int, file: String, sAssignmentID: Int, fileName: String) {
        self.id = id
        self.file = file
        self.sAssignmentID = sAssignmentID
        self.fileName = fileName
    }
}
