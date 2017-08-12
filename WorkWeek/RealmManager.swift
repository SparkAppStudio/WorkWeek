//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

class WeeklyObject: Object {
    dynamic var weekAndTheYear: String?
    let dailyObjects = List<DailyObject>()
    var totalWorkTime: TimeInterval {
        return dailyObjects.reduce(0.0) { (sum, daily) in
            return sum + daily.workTime
        }
    }
    var weekInterval: String {
        if let begin = dailyObjects.first?.date, let end = dailyObjects.last?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            let beginString = dateFormatter.string(from: begin)
            let endString = dateFormatter.string(from: end)
            return beginString + " - " + endString
        } else {
            Log.log(.error,
                    "Error formatting WeekInterval. first: \(dailyObjects.first.debugDescription)"
                    +
                    " second: \(dailyObjects.last.debugDescription)")
            return "..."
        }

    }
    override static func primaryKey() -> String? {
        return #keyPath(WeeklyObject.weekAndTheYear)
    }
}

class DailyObject: Object {
    dynamic var dateString: String?
    dynamic var date: Date?
    let allEventsRaw = List<Event>()

    struct Pair {
        let start: Event
        let end: Event

        var interval: TimeInterval {
            return DateInterval(start: start.eventTime, end: end.eventTime).duration
        }
    }

    var validWorkingDurations: [Pair] {

        var pairs = [Pair]()

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

    var workTime: TimeInterval {
        return validWorkingDurations.reduce(0) { $0 + $1.interval }
    }

    override static func primaryKey() -> String? {
        return #keyPath(DailyObject.dateString)
    }

    var events: [Event] {
        return Array(allEventsRaw)
    }

}

class Event: Object {
    dynamic var eventTime: Date = Date()
    dynamic private var kindStorage: String? = ""

    var kind: NotificationCenter.CheckInEvent? {
        guard let kindStorage = kindStorage else {
            Log.log(.error, "event \(self) has missing or invalid `kind`")
            return nil
        }
        return NotificationCenter.CheckInEvent(rawValue: kindStorage)
    }

    convenience init(kind: NotificationCenter.CheckInEvent, time: Date) {
        self.init()
        self.kindStorage = kind.rawValue
        self.eventTime = time
    }

}

class RealmManager {

    static var dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = DateFormatter.Style.short
        fmt.timeZone = TimeZone.current
        return fmt
    }()

    static let shared = RealmManager()

    private var realm: Realm = {
        do {
            let realm = try Realm()
            Log.log("Realm file path\(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
            return realm
        } catch {
            Log.log(.error, "Cannot Access Realm Database. error \(error.localizedDescription)")
        }
        fatalError("Realm Could not get created.. Nothing to see here")
    }()

    // MARK: - Query Operations
    func queryDailyObject(for date: Date) -> DailyObject? {
        let key = dailyPrimaryKeyBased(on: date)
        let dailyObject = realm.object(ofType: DailyObject.self, forPrimaryKey: key)
        return dailyObject
    }

    func queryAllDailyObjects() {
        let allDailyObject = realm.objects(DailyObject.self)
        Log.log(allDailyObject.debugDescription)
    }

    func queryAllObjects<T: Object>(ofType type: T.Type) -> [T] {
        let allObjects = realm.objects(type)
        Log.log(allObjects.debugDescription)
        return Array(allObjects)
    }

    // MARK: - Delete Operations
    func removeAllObjects() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            Log.log(.error, error.localizedDescription)
        }
    }

    // MARK: - Update Opertions
    func saveDataToRealm(for checkInEvent: NotificationCenter.CheckInEvent) {
        let todayDate = Date()

        let todayKey = dailyPrimaryKeyBased(on: todayDate)
        let weeklyKey = weeklyPrimaryKeyBased(on: todayDate)

        let event = Event(kind: checkInEvent, time: Date())

        // update DailyObject with new event
        do {
            try realm.write {
                realm.add(event)
                // Fetch daily object for the day
                let dailyObjectResult = realm.object(ofType: DailyObject.self, forPrimaryKey: todayKey)

                // Create a daily object without updating event
                let createdDailyObject = realm.create(DailyObject.self,
                                                      value: [#keyPath(DailyObject.dateString): todayKey,
                                                              #keyPath(DailyObject.date): todayDate],
                                                      update: true)

                // Append the event inside allEvents
                createdDailyObject.allEventsRaw.append(event)

                let weeklyObject = realm.create(WeeklyObject.self,
                                                value: [#keyPath(WeeklyObject.weekAndTheYear): weeklyKey],
                                                update: true)

                // After DailyObject is created for the first time, need to Save it into weekly
                if dailyObjectResult == nil {
                    weeklyObject.dailyObjects.append(createdDailyObject)
                }
            }
        } catch {
            Log.log(.error, "Failed to save new Event. \(error.localizedDescription)")
        }
    }


    func dailyPrimaryKeyBased(on date: Date) -> String {
        return RealmManager.dateFormatter.string(from: date)
    }

    func weeklyPrimaryKeyBased(on date: Date ) -> String {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents(in: .current, from: date)
        guard let week = dateComponents.weekOfYear else { return ""}
        guard let year = dateComponents.year else { return ""}
        return "\(week)" + "\(year)"
    }

    // MARK: - User

    /// Saves a base user, to realm. The user object has sane defaults.
    /// Calling this again, if a user exists, has no effect.
    func saveInitialUser() {

        func userExists() -> Bool {
            return realm.objects(User.self).count > 0
        }

        guard !userExists() else { return }

        let user = User()
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            Log.log(.error, "Failed to save initial User. \(error.localizedDescription)")
        }
    }

    func update(user: User, with weekdays: User.Weekdays) {
        unhandledErrorWrite( user.weekdays = weekdays)
    }
    func updateHours(for user: User, with hours: Double) {
        unhandledErrorWrite( user.hoursInWorkDay = hours)
    }

    func updateNotificationsChoice(for user: User, with choice: User.NotificationChoice) {
        unhandledErrorWrite( user.notificationChoice =  choice)
    }

    func unhandledErrorWrite(_ action: @autoclosure () -> Void ) {
        do {
            try realm.write {
                action()
            }
        } catch {
            Log.log(.error, "Failed Write. \(error.localizedDescription)")
        }
    }


}
