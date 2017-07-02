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

    static var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            Log.log("Cannot Access Database")
        }
        return self.realm
    }

    // MARK: - Save Operations
    func saveDailyActivities(_ dailyOject: DailyObject) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dailyOject)
            }

        } catch let error as NSError {
            //handle error
            Log.log(error.localizedDescription)
        }

    }

    // MARK: - Query Operations
    func getDailyObject(for date: Date) -> DailyObject? {
        let key = date.primaryKeyBasedOnDate()
        do {
            let realm = try Realm()
            let dailyObject = realm.object(ofType: DailyObject.self, forPrimaryKey: key)
            return dailyObject
        } catch let error as NSError {
            Log.log(error.localizedDescription)
            return DailyObject()
        }
    }

    func displayAllDailyObjects() {
        do {
            let realm = try Realm()
            let allDailyObject = realm.objects(DailyObject.self)
            Log.log(allDailyObject.debugDescription)
        } catch let error as NSError {
            //handle error
            Log.log(error.localizedDescription)
        }
    }

    func getAllWeeklyObjects() {

    }

    // MARK: - Delete Operations

    func removeAllObjects() {
        do {
            let realm = try Realm()
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
        let key = Date().primaryKeyBasedOnDate()
        let todayDate = Date()
        // Create a new Event
        let event = Event(eventName: checkInEvents.rawValue, eventTime: Date())
        // update DailyObject with new event
        let updateKeypath: String
        switch checkInEvents {
        case .leftHome:
            updateKeypath = "timeLeftHome"
        case .arriveWork:
            updateKeypath = "timeArriveWork"
        case .leftWork:
            updateKeypath = "timeLeftWork"
        case .arriveHome:
            updateKeypath = "timeArriveHome"
        }
        do {
            try RealmManager.realm.write {
                RealmManager.realm.add(event)
                RealmManager.realm.create(DailyObject.self,
                                          value: ["dateString": key,
                                                  updateKeypath: event,
                                                  "date": todayDate],
                                          update: true)
            }
        } catch {
            Log.log("error")
        }
    }
}
