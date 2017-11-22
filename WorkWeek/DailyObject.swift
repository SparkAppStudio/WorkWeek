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

    convenience init(date: Date) {
        self.init()
        self.date = date
    }

    @objc dynamic var dateString: String?
    @objc dynamic var date: Date? // TODO: Write a migrate to make date non-optional

    private let allEventsRaw = List<Event>()

    var events: [Event] {
        return Array(allEventsRaw)
    }

    var firstEvent: Event? {
        return events.first
    }

    override static func primaryKey() -> String? {
        return #keyPath(DailyObject.dateString)
    }

    func add(_ event: Event) {
        allEventsRaw.append(event)
    }

    func insertArriveWorkOnNextDay() {
        // Check the first event of the next day, if not arriveWork, insert arriveWork
        // at the start of the next day
        guard let startOfNextDay = date!.startOfNextDay else { return }
        let nextDayObject = DataStore.shared.queryDailyObject(for: startOfNextDay)
        let firstEventOfNextDay = nextDayObject?.firstEvent
        if nextDayObject == nil || (firstEventOfNextDay?.kind != .arriveWork) {
            DataStore.shared.saveDataToRealm(for: .arriveWork, startOfNextDay)
        }
    }

    var isAtWork: Bool {
        guard let lastEvent = events.last else {
            return false // no events yet today, not at work
        }
        return lastEvent.kind == NotificationCenter.CheckInEvent.arriveWork
    }

    var wasAtWork: Bool {
        // 2, first event of the day is arriveHome or leftWork (not arriveWork)
        // and the last event of the previous day is arrive work
        let firstEvent = events.first
        let previousDailyObject = DataStore.shared.previousDailyObject(fromDate: date!)
        let lastEventOfPreviousDay = previousDailyObject?.events.last

//        let isFristEventArriveHome = firstEvent?.kind == .arriveHome
        let isFirstEventLeaveWork = firstEvent?.kind == .leaveWork
        let isLastEventOfPreviousDayArriveWork = lastEventOfPreviousDay?.kind == .arriveWork

        if (/*isFristEventArriveHome ||*/isFirstEventLeaveWork) && isLastEventOfPreviousDayArriveWork {
            return true
        }
        return false
    }

    var completedWorkTime: TimeInterval {
        let now = Date()
        var totalWorkTime: Double = 0.0
        let priorDurations = validWorkingDurations.reduce(0) { $0 + $1.interval }
        totalWorkTime += priorDurations

        if wasAtWork, let leftWork = events.first {
            let startOfDay = date!.startOfDay
            totalWorkTime += leftWork.eventTime.timeIntervalSince(startOfDay)
        }

        if isAtWork, let arriveWork = events.last {
            if !Calendar.current.isDate(now, inSameDayAs: date!) {
                let endOfDayDate = date!.endOfDay
                totalWorkTime += endOfDayDate.timeIntervalSince(arriveWork.eventTime)
            } else {
                totalWorkTime += now.timeIntervalSince(arriveWork.eventTime)
            }
        }
        return totalWorkTime
    }


    var oldcompletedWorkTime: TimeInterval {
        if isAtWork, let arriveWork = events.last {
            let now = Date()
            let priorDurations = validWorkingDurations.reduce(0) { $0 + $1.interval }
            // The date must exist when creating the DailyObject
            guard Calendar.current.isDate(now, inSameDayAs: date!) else {
                // create a 11:59PM date on the DailyObject's date
                let endOfDayDate = date!.endOfDay
                // Check the first event of the next day, if not arriveWork, insert arriveWork
                // at the start of the next day
//                insertArriveWorkOnNextDay() // probaly don't want to modify
                return priorDurations + endOfDayDate.timeIntervalSince(arriveWork.eventTime)
            }
            // if now is no longer the same day as the daily object, append a leave work at time 11:59
            return priorDurations + now.timeIntervalSince(arriveWork.eventTime)
        }
        return validWorkingDurations.reduce(0) { $0 + $1.interval }
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
