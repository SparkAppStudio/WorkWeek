//
//  RealmManager.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/17/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import RealmSwift

class WeeklyObject: Object {
    dynamic var weekAndTheYear: String?
    let dailyObjects = List<DailyObject>()
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
    override static func primaryKey() -> String? {
        return #keyPath(DailyObject.dateString)
    }
}

class Event: Object {
    var eventName: String?
    var eventTime: Date?
    convenience init(eventName: String, eventTime: Date) {
        self.init()
        self.eventName = eventName
        self.eventTime = eventTime
    }
}

class RealmManager {

    static let shared = RealmManager()

    private var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            Log.log(.error, "Cannot Access Realm Database. error \(error.localizedDescription)")
        }
        return self.realm
    }

    // MARK: - Query Operations
    func queryDailyObject(for date: Date) -> DailyObject? {
        let key = date.primaryKeyBasedOnDate()
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

        let todayKey = todayDate.primaryKeyBasedOnDate()
        let weeklyKey = todayDate.weeklyPrimaryKeyBasedOnDate()

        let event = Event(eventName: checkInEvent.rawValue, eventTime: Date())
        let eventKeypath = dailyObjectKeyPath(for: checkInEvent)

        // update DailyObject with new event
        do {
            try realm.write {
                realm.add(event)
                let dailyObjectResult = realm.object(ofType: DailyObject.self, forPrimaryKey: todayKey)
                let createdDailyObject = realm.create(DailyObject.self,
                                                     value: ["dateString": todayKey,
                                                             eventKeypath: event,
                                                             "date": todayDate],
                                                     update: true)
                let weeklyObject = realm.create(WeeklyObject.self,
                                                value: ["weekAndTheYear": weeklyKey],
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

}
