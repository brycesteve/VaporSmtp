

import Foundation

public struct Attachment {
    let name: String
    let contentType: String
    let data: Data

    public init(name: String, contentType: String, data: Data) {
        self.name = name
        self.contentType = contentType
        self.data = data
    }
}
