//
//  RealmManager.swift
//  WorkWeek
//
//  Created by YupinHuPro on 6/17/17.
//  Copyright © 2017 Spark App Studio. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class WeeklyObject: Object {
    dynamic var weekOfTheYear: String?
    let dailyObjects = List<DailyObject>()
    override static func primaryKey() -> String? {
        return "weekOfTheYear"
    }
}

class DailyObject: Object {
    dynamic var dateString: String?
    dynamic var timeLeftHome: Event?
    dynamic var timeArriveWork: Event?
    dynamic var timeLeftWork: Event?
    dynamic var timeArriveHome: Event?
    override static func primaryKey() -> String? {
        return "dateString"
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
    func updateDailyActivities(_ dailyObject: DailyObject, forCheckInEvents: NotificationCenter.CheckInEvents) {
        do {
            let realm = try Realm()

            //DailyObjecy
            guard let key = dailyObject.dateString else {return}
            let dailyObjectQuery = realm.object(ofType: DailyObject.self, forPrimaryKey: key)

            try realm.write {
                if let currentDailyObject = dailyObjectQuery {
                    switch forCheckInEvents {
                    case .leftHome:
                        currentDailyObject.timeLeftHome = dailyObject.timeLeftHome
                    case .arriveWork:
                        currentDailyObject.timeArriveWork = dailyObject.timeArriveWork
                    case .leftWork:
                        currentDailyObject.timeLeftWork = dailyObject.timeLeftWork
                    case .arriveHome:
                        currentDailyObject.timeArriveHome = dailyObject.timeArriveHome
                    }
                } else {
                    //Create a new daily activity and update it
                    realm.add(dailyObject)
                }
            }
        } catch let error as NSError {
            Log.log(error.localizedDescription)
        }
    }
}
