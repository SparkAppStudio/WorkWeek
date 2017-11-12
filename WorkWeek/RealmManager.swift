//
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

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

    var getUserCalculator: UserHoursCalculator {
        let user = realm.objects(User.self).first ?? fetchOrCreateUser()
        let dailyObject = queryDailyObject()
        let weeklyObject = queryWeeklyObject()
        let previous = previousWeeklyObject()

        return UserHoursCalculator(user: user, dailyObject: dailyObject, weeklyObject: weeklyObject, previousWeek: previous)
    }

    // MARK: - Query Operations

    func queryDailyObject(for date: Date = Date()) -> DailyObject? {
        let key = dailyPrimaryKeyBased(on: date)
        let dailyObject = realm.object(ofType: DailyObject.self, forPrimaryKey: key)
        return dailyObject
    }

    func queryAllDailyObjects() {
        let allDailyObject = realm.objects(DailyObject.self)
        Log.log(allDailyObject.debugDescription)
    }

    func queryWeeklyObject(for date: Date = Date()) -> WeeklyObject? {
        let key = weeklyPrimaryKeyBased(on: date)
        let weeklyObject = realm.object(ofType: WeeklyObject.self, forPrimaryKey: key)
        return weeklyObject
    }

    func previousWeeklyObject(fromDate startDate: Date = Date()) -> WeeklyObject? {
        let todayComps = Calendar.current.dateComponents([.weekOfYear, .weekday], from: startDate)
        let lastWeek = Calendar.current.nextDate(after: Date.distantPast,
                                                 matching: todayComps,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward)
        guard let lastWeekDate = lastWeek else { return nil }
        return queryWeeklyObject(for: lastWeekDate)
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
                createdDailyObject.add(event)

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

    func weeklyPrimaryKeyBased(on date: Date) -> String {
        let cal = Calendar.current
        let dateComponents = cal.dateComponents(in: .current, from: date)
        guard let week = dateComponents.weekOfYear else { return ""}
        guard let year = dateComponents.year else { return ""}
        return "\(week)" + "\(year)"
    }

    // MARK: - User

    /// Saves a base user, to realm. The user object has sane defaults.
    /// Calling this again, if a user exists, has no effect.
    @discardableResult
    func fetchOrCreateUser() -> User {

        func userExists() -> Bool {
            return realm.objects(User.self).count > 0
        }

        guard !userExists() else { return realm.objects(User.self).first! }

        let user = User()
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            Log.log(.error, "Failed to save initial User. \(error.localizedDescription)")
        }
        return user
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

class UserHoursCalculator {
    private let user: User
    private let dailyObject: DailyObject?
    private let weeklyObject: WeeklyObject?
    private let previousWeek: WeeklyObject?

    init(user: User, dailyObject: DailyObject?, weeklyObject: WeeklyObject?, previousWeek: WeeklyObject?) {
        self.user = user
        self.dailyObject = dailyObject
        self.weeklyObject = weeklyObject
        self.previousWeek = previousWeek
    }

    var hasDataForThisWeek: Bool {
        return weeklyObject != nil
    }

    var hasDataForToday: Bool {
        return dailyObject != nil
    }

    var hasDataForPreviousWeek: Bool {
        return previousWeek != nil
    }

    var timeSoFarToday: TimeInterval {
        guard let dailyObject = dailyObject else { return 0.0 }
        let priorDurations = dailyObject.completedWorkTime
        return priorDurations
    }

    var userTimeLeftToday: TimeInterval {
        return usersDefaultWorkDayLength - timeSoFarToday
    }

    var usersDefaultWorkDayLength: TimeInterval {
        return user.hoursInWorkDay * 60.0 * 60.0 // convert hours to seconds
    }

    var userTimeLeftInWeek: TimeInterval {
        guard let weeklyObject = weeklyObject else {
            // No weekly object?
            return 0.0
        }
        let workHoursPerWeek = user.hoursInWorkDay * Double(user.weekdays.numberSelected)
        let workHoursInSeconds = workHoursPerWeek * 60 * 60
        return workHoursInSeconds - weeklyObject.totalWorkTime
    }

    var percentOfWorkRemaining: Double {
        return userTimeLeftToday / usersDefaultWorkDayLength

    var notificationChoice: User.NotificationChoice {
        return user.notificationChoice
    }

}
