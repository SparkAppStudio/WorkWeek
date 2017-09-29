//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

private struct Pair {
    let start: Event
    let end: Event

    var interval: TimeInterval {
        return DateInterval(start: start.eventTime, end: end.eventTime).duration
    }
}

class DailyObject: Object {
    @objc dynamic var dateString: String?
    @objc dynamic var date: Date?

    private let allEventsRaw = List<Event>()

    var events: [Event] {
        return Array(allEventsRaw)
    }

    override static func primaryKey() -> String? {
        return #keyPath(DailyObject.dateString)
    }

    func add(_ event: Event) {
        allEventsRaw.append(event)
    }

    var completedWorkTime: TimeInterval {
        return validWorkingDurations.reduce(0) { $0 + $1.interval }
    }

    private var validWorkingDurations: [Pair] {

        func discardLeadingLeaves(_ list: [Event]) -> [Event] {
            return Array(list.drop(while: { $0.kind == .leaveWork }))
        }

        func discardTrailingArrivals(_ list: [Event]) -> [Event] {
            return Array(list.reversed().drop(while: { $0.kind == .arriveWork}).reversed())
        }

        func discardNoneWorkEvents(_ list: [Event]) -> [Event] {
            return list.filter { $0.kind == .arriveWork || $0.kind == .leaveWork }
        }

        func getPair(_ sanitized: [Event]) -> [Pair] {
            var mutableCopy = sanitized
            guard let arriveWork = findArrival(&mutableCopy) else { return [] }
            guard let leaveWork = findDeparture(&mutableCopy) else { return [] }
            let foundPair = Pair(start: arriveWork, end: leaveWork)
            return [foundPair] + getPair(Array(mutableCopy))
        }

        func findArrival(_ mutableCopy: inout [Event]) -> Event? {
            guard !mutableCopy.isEmpty else { return nil }
            let arriveArray = mutableCopy.prefix { $0.kind == .arriveWork }
            defer {  mutableCopy = Array(mutableCopy.drop { $0.kind == .arriveWork }) }
            return arriveArray.last
        }

        func findDeparture(_ mutableCopy: inout [Event]) -> Event? {
            guard !mutableCopy.isEmpty else { return nil }
            let departure = mutableCopy.removeFirst()
            guard departure.kind == .leaveWork else { return nil }
            defer { mutableCopy = Array(mutableCopy.drop(while: {$0.kind == .leaveWork})) }
            return departure
        }

        return Array(allEventsRaw)
            |> discardLeadingLeaves
            |> discardTrailingArrivals
            |> discardNoneWorkEvents
            |> getPair

    }
}
