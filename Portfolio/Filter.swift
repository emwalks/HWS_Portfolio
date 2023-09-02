//
//  Filter.swift
//  Portfolio
//
//  Created by Emma Walker - TVandMobile Platforms - Core Engineering on 02/09/2023.
//

import Foundation


struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationData = Date.distantPast
    var tag: Tag?
    
    private static let secondsInOneDay: TimeInterval = 86400
    private static let daysInWeek: TimeInterval = 7
    
    static var all = Filter(id: UUID(), name: "All Resources", icon: "books.vertical")
    static var recent = Filter(id: UUID(), name: "Recent Resources", icon: "clock", minModificationData:
    // last -7 days
        .now.addingTimeInterval(secondsInOneDay * -daysInWeek))
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
