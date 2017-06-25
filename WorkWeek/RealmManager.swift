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

class DailyActivities: Object {
    dynamic var dateString: String?
    dynamic var timeLeftHome: NSDate?
    dynamic var timeArriveWork: NSDate?
    dynamic var timeLeftWork: NSDate?
    dynamic var timeArriveHome: NSDate?

    override static func primaryKey() -> String? {
        return "dateString"
    }
}

class RealmManager {

    static let shared = RealmManager()

    func saveDailyActivities(_ dailyActivities: DailyActivities) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dailyActivities)
            }

        } catch let error as NSError {
            //handle error
            print(error.localizedDescription)
        }

    }

    func getTodayObject() -> DailyActivities {
        do {
            let realm = try Realm()
            let currentDailyActivity = realm.objects(DailyActivities.self)
            .filter("dateString = '6/25/17'")
            return currentDailyActivity.first!
        } catch let error as NSError {
            print(error.localizedDescription)
            return DailyActivities()
        }
    }

    func displayAllDailyActivies() {
        do {
            let realm = try Realm()
            let allActivities = realm.objects(DailyActivities.self)
            print(allActivities)

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

    func updateDailyActivities(_ dailyActivities: DailyActivities, forNote: NotificationCenter.Notes) {
        do {
            let realm = try Realm()

            let currentDailyActivity = realm.objects(DailyActivities.self)
                                            .filter("dateString = '6/25/17'")

            switch forNote {
            case .leftHome:
                try realm.write {
                    currentDailyActivity.first?.timeLeftHome = dailyActivities.timeLeftHome
                }

            case .arriveWork:
                try realm.write {
                    currentDailyActivity.first?.timeArriveWork = dailyActivities.timeArriveWork
                }
            case .leftWork:
                try realm.write {
                    currentDailyActivity.first?.timeLeftWork = dailyActivities.timeLeftWork
                }
            case .arriveHome:
                try realm.write {
                    currentDailyActivity.first?.timeArriveHome = dailyActivities.timeArriveHome
                }
            }

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
