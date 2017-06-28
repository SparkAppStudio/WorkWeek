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
    var eventTime: NSDate?

    convenience init(eventName: String, eventTime: NSDate) {
        self.init()
        self.eventName = eventName
        self.eventTime = eventTime
    }
}

class RealmManager {

    static let shared = RealmManager()

    func saveDailyActivities(_ dailyOject: DailyObject) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dailyOject)
            }

        } catch let error as NSError {
            //handle error
            print(error.localizedDescription)
        }

    }

    func getDailyObject(for date: NSDate) -> DailyObject? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let key = dateFormatter.string(from: date as Date)
        do {
            let realm = try Realm()
            let dailyObject = realm.object(ofType: DailyObject.self, forPrimaryKey: key)
            return dailyObject
        } catch let error as NSError {
            print(error.localizedDescription)
            return DailyObject()
        }

    }

    func displayAllDailyObjects() {
        do {
            let realm = try Realm()
            let allDailyObject = realm.objects(DailyObject.self)
            print(allDailyObject)

        } catch let error as NSError {
            //handle error
            print(error.localizedDescription)
        }
    }

    func removeAllObjects() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            //handle error
            print(error.localizedDescription)
        }
    }

    func updateDailyActivities(_ dailyObject: DailyObject, forNote: NotificationCenter.Notes) {

        do {
            let realm = try Realm()

            guard let key = dailyObject.dateString else {return}

            let dailyActivityQueryResult = realm.object(ofType: DailyObject.self, forPrimaryKey: key)

            try realm.write {
                if let currentDailyActivity = dailyActivityQueryResult {
                    switch forNote {
                    case .leftHome:
                        currentDailyActivity.timeLeftHome = dailyObject.timeLeftHome
                    case .arriveWork:
                        currentDailyActivity.timeArriveWork = dailyObject.timeArriveWork
                    case .leftWork:
                        currentDailyActivity.timeLeftWork = dailyObject.timeLeftWork
                    case .arriveHome:
                        currentDailyActivity.timeArriveHome = dailyObject.timeArriveHome
                    }
                } else {
                    //Create a new daily activity and update it
                    realm.add(dailyObject)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
