import Foundation

extension DateInterval {
    static var defaultInterval: DateInterval {
        let now = Date()
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: now)!
        return DateInterval(start: oneWeekAgo, end: now)
    }
}
