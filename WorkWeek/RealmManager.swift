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
            Log.log(error.localizedDescription)
        }

    }

    func displayAllDailyActivies() {
        do {
            let realm = try Realm()
            let allActivities = realm.objects(DailyActivities.self)
            Log.log(allActivities.debugDescription)

        } catch let error as NSError {
            //handle error
            Log.log(error.localizedDescription)
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
            Log.log(error.localizedDescription)
        }
    }

    func updateDailyActivities(_ dailyActivities: DailyActivities) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dailyActivities, update: true)
            }
        } catch let error as NSError {
            Log.log(error.localizedDescription)
        }
    }
}
