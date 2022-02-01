//
//  Date+String.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/30/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

class DateTime {

    class func dateTimeFormat(time: String) -> String {

        var unixTimestamp = Double(time)
        unixTimestamp = unixTimestamp!
        let date = Date(timeIntervalSince1970: unixTimestamp!)

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        dateFormatter.dateFormat = "dd/MM/yyyy - HH:mm"

        return dateFormatter.string(from: date)
    }

    class func timeFormat(time: String) -> String {

        guard let unixTimestamp = Double(time) else { return "" }
        let date = Date(timeIntervalSince1970: unixTimestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: date)
    }

    class func dateFormat(time: String) -> String {

        guard let unixTimestamp = Double(time) else { return "" }

        let date = Date(timeIntervalSince1970: unixTimestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        dateFormatter.dateFormat = "dd/MM/yyyy"

        return dateFormatter.string(from: date)
    }

    class func monthFormat(time: String) -> String {

        guard let unixTimestamp = Double(time) else { return "" }

        let date = Date(timeIntervalSince1970: unixTimestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        dateFormatter.dateFormat = "dd MMM"

        return dateFormatter.string(from: date)
    }

    class func getTime(from time: Int) -> String {
        let unixTimestamp = Double(time)
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let timeAgo = date.timeAgoSinceNow()
        return timeAgo
    }

    class func appFormat(time: String) -> String {

        guard let unixTimestamp = Double(time) else { return "" }

        let date = Date(timeIntervalSince1970: unixTimestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"

        return dateFormatter.string(from: date)
    }

    class func yearMonthFormat(time: String) -> String {

        guard let unixTimestamp = Double(time) else { return "" }

        let date = Date(timeIntervalSince1970: unixTimestamp)

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        dateFormatter.dateFormat = "YYYY-MM"

        return dateFormatter.string(from: date)
    }

}

// -------------------------------------
// MARK: - persian date
// -------------------------------------
extension String {
    func toDate() -> String {
        return DateTime.dateFormat(time: self)
    }

    func toDateTime() -> String {
        return DateTime.dateTimeFormat(time: self)
    }

    func toTime() -> String {
        return DateTime.timeFormat(time: self)
    }

    func toMonth() -> String {
        return DateTime.monthFormat(time: self)
    }

    func toAppFormat() -> String {
        return DateTime.appFormat(time: self)
    }

    func toMonthAndYear() -> String {
        return DateTime.yearMonthFormat(time: self)
    }

}

extension Int {
    func timeAgo() -> String {
        return DateTime.getTime(from: self)
    }
}
