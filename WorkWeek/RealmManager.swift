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
    override static func primaryKey() -> String? {
        return #keyPath(WeeklyObject.weekAndTheYear)
    }
}

class DailyObject: Object {
    dynamic var dateString: String?
    dynamic var date: Date?
    dynamic var timeLeftHome: Event?
    dynamic var timeArriveWork: Event?
    dynamic var timeLeftWork: Event?
    dynamic var timeArriveHome: Event?
    var workTime: TimeInterval {
        guard let arriveWorkEventTime = timeArriveWork?.eventTime,
            let leftWorkEventTime = timeLeftWork?.eventTime else {
                return 0.0
        }
        return leftWorkEventTime.timeIntervalSince(arriveWorkEventTime)
    }
    override static func primaryKey() -> String? {
        return #keyPath(DailyObject.dateString)
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

    private var realm: Realm {
        do {
            let realm = try Realm()
            Log.log("Realm file path\(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
            return realm
        } catch {
            Log.log(.error, "Cannot Access Realm Database. error \(error.localizedDescription)")
        }
        return self.realm
    }

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
        let eventKeypath = dailyObjectKeyPath(for: checkInEvent)

        // update DailyObject with new event
        do {
            try realm.write {
                realm.add(event)
                let dailyObjectResult = realm.object(ofType: DailyObject.self, forPrimaryKey: todayKey)
                let createdDailyObject = realm.create(DailyObject.self,
                                                      value: [#keyPath(DailyObject.dateString): todayKey,
                                                              eventKeypath: event,
                                                              #keyPath(DailyObject.date): todayDate],
                                                      update: true)
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

    func dailyObjectKeyPath(for checkInEvent: NotificationCenter.CheckInEvent) -> String {
        let updateKeypath: String
        switch checkInEvent {
        case .leaveHome:
            updateKeypath = #keyPath(DailyObject.timeLeftHome)
        case .arriveWork:
            updateKeypath = #keyPath(DailyObject.timeArriveWork)
        case .leaveWork:
            updateKeypath = #keyPath(DailyObject.timeLeftWork)
        case .arriveHome:
            updateKeypath = #keyPath(DailyObject.timeArriveHome)
        }
        return updateKeypath
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
        do {
            try realm.write {
                user.weekdays = weekdays
            }
        } catch {
            Log.log(.error, "Failed to update Weekdays for user: \(user). \(error.localizedDescription)")
        }
    }
}
