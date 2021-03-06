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

    convenience init(date: Date = Date()) {
        self.init()
        self.date = date
    }

    @objc dynamic var dateString: String?
    @objc dynamic var date: Date? // TODO: Write a migrate to make date non-optional

    var unWrappedDate: Date {
        // TODO: Will remove this after figure out Realm data migration
        return date!
    }

    private let allEventsRaw = List<Event>()

    var events: [Event] {
        return Array(allEventsRaw)
    }

    var firstEvent: Event? {
        return events.first
    }

    var lastEvent: Event? {
        return events.last
    }

    override static func primaryKey() -> String? {
        return #keyPath(DailyObject.dateString)
    }

    func add(_ event: Event) {
        allEventsRaw.append(event)
    }

    var isAtWork: Bool {
        guard let lastEvent = events.last else {
            return false // no events yet today, not at work
        }
        return lastEvent.kind == NotificationCenter.CheckInEvent.arriveWork
    }

    var isAtHome: Bool {
        guard let lastEvent = events.last else {
            return false // no events yet today, not at home
        }
        return lastEvent.kind == NotificationCenter.CheckInEvent.arriveHome
    }

    // if the first event of the day is leftWork
    // and the last event of the previous day is arrive work
    // that means I worked past midnight last night
    var wasAtWork: Bool {
        let isFirstEventOfTheDayLeaveWork = firstEvent?.kind == .leaveWork
        let isLastEventOfPreviousDayArriveWork = DataStore.shared.isLastEventOfPreviousDayArriveWork(for: self)
        if isFirstEventOfTheDayLeaveWork && isLastEventOfPreviousDayArriveWork {
            return true
        }
        return false
    }

    var completedWorkTime: TimeInterval {
        let now = Date()
        var totalWorkTime: Double = 0.0
        let validPairsDurations = validWorkingDurations.reduce(0) { $0 + $1.interval }
        totalWorkTime += validPairsDurations
        totalWorkTime += timeSoFar(nowDate: now)
        totalWorkTime += betweenBeginningOfTheDayAndLeaveWorkDuration()
        totalWorkTime += betweenArriveWorkAndMidnightDuration(nowDate: now)
        return totalWorkTime
    }

    // If I worked past midnight last night, add the time interval between
    // beginning of the day (12:00AM) until I leaveWork
    private func betweenBeginningOfTheDayAndLeaveWorkDuration() -> TimeInterval {
        if wasAtWork {
            guard let leaveWork = events.first else { return 0 }
            return leaveWork.midnightToLeaveInterval
        } else {
            return 0.0
        }
    }

    // If I work pass midnight tonight, add the time interval between
    // arriveWork and midnight (11:59PM)
    private func betweenArriveWorkAndMidnightDuration(nowDate: Date = Date()) -> TimeInterval {
        if isAtWork {
            // if the last event of the day is arriveWork, and we already work past
            // that day, we then calculate the duration between arriveWork and 11:59PM
            guard let arriveWork = events.last else { return 0 }
            let isSameDay = Calendar.current.isDate(nowDate, inSameDayAs: unWrappedDate)
            return isSameDay ? 0.0 : arriveWork.arriveWorkToMidnightInterval
        } else {
            return 0.0
        }
    }

    // This is where the time accumulates and updates the count down view controller data
    // for the time that I am still at work
    private func timeSoFar(nowDate: Date = Date()) -> TimeInterval {
        if isAtWork, let arriveWork = events.last {
            let isSameDay = Calendar.current.isDate(nowDate, inSameDayAs: unWrappedDate)
            return isSameDay ? nowDate.timeIntervalSince(arriveWork.eventTime) : 0.0
        } else {
            return 0.0
        }
    }

    var weekDay: Int? {
        let cal = Calendar.current
        let dateComp = cal.dateComponents(in: .current, from: date!)
        return dateComp.weekday
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
