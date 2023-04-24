import Foundation

public extension JSONDecoder {

    static var norgesBankDecoder: JSONDecoder {
        let decoder = JSONDecoder()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let stringValue = try container.decode(String.self)
            guard let date = dateFormatter.date(from: stringValue) else {
                // note:
                // TypeMismatch errors occur when an expected type of a value or variable is different from the actual
                // type. For example, if you expected a variable to be of type Int, but it was actually of type String,
                // a TypeMismatch error would occur.
                throw DecodingError.typeMismatch(
                    Date.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription:
                            """
                            Failed to parse date string. Expecting standartT formatted date.
                            \"yyyy-MM-dd'T'HH:mm:ss\"
                            """
                    )
                )
            }
            return date
        })
        return decoder
    }
}
