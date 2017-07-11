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
            return realm
        } catch {
            Log.log("Cannot Access Database")
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
        } catch let error as NSError {
            //handle error
            Log.log(error.localizedDescription)
        }
    }

    // MARK: - Update Opertions
    func saveDataToRealm(for checkInEvents: NotificationCenter.CheckInEvents) {
        // Check if there alredy exists an daily object for today
        let todayDate = Date()
        let key = dailyPrimaryKeyBased(on: todayDate)
        let weeklyKey = weeklyPrimaryKeyBased(on: todayDate)
        // Create a new Event
        let event = Event(eventName: checkInEvents.rawValue, eventTime: Date())
        // update DailyObject with new event
        let updateKeypath: String
        switch checkInEvents {
        case .leaveHome:
            updateKeypath = "timeLeftHome"
        case .arriveWork:
            updateKeypath = "timeArriveWork"
        case .leaveWork:
            updateKeypath = "timeLeftWork"
        case .arriveHome:
            updateKeypath = "timeArriveHome"
        }
        do {
            try realm.write {
                realm.add(event)
                let dailyObjectResult = realm.object(ofType: DailyObject.self, forPrimaryKey: key)
                let createdDailyObject = realm.create(DailyObject.self,
                                                     value: ["dateString": key,
                                                             updateKeypath: event,
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
            Log.log("error")
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

}
