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

struct Activity {
    var activityName: String?
    var activityTime: NSDate?
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

    func getTodayObject() -> [Activity] {
        var todayActivity = [Activity]()
        do {
            let realm = try Realm()
            let currentDailyActivity = realm.objects(DailyActivities.self)
                .filter("dateString = '6/25/17'")

            if let timeLeftHome = currentDailyActivity.first?.timeLeftHome {
                let activity = Activity(activityName: NotificationCenter.Notes.leftHome.rawValue,
                                        activityTime: timeLeftHome)
                todayActivity.append(activity)
            }

            if let timeArriveWork = currentDailyActivity.first?.timeArriveWork {
                let activity = Activity(activityName: NotificationCenter.Notes.arriveWork.rawValue,
                                        activityTime: timeArriveWork)
                todayActivity.append(activity)
            }

            if let timeLeftWork = currentDailyActivity.first?.timeLeftWork {
                let activity = Activity(activityName: NotificationCenter.Notes.leftWork.rawValue,
                                        activityTime: timeLeftWork)
                todayActivity.append(activity)
            }

            if let timeArriveHome = currentDailyActivity.first?.timeArriveHome {
                let activity = Activity(activityName: NotificationCenter.Notes.arriveHome.rawValue,
                                        activityTime: timeArriveHome)
                todayActivity.append(activity)
            }

            return todayActivity

        } catch let error as NSError {
            print(error.localizedDescription)
            return [Activity]()
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

            let dailyActivityQueryResult = realm.objects(DailyActivities.self)
                .filter("dateString = '6/25/17'")

            try realm.write {
                if let currentDailyActivity = dailyActivityQueryResult.first {
                    switch forNote {
                    case .leftHome:
                        currentDailyActivity.timeLeftHome = dailyActivities.timeLeftHome
                    case .arriveWork:
                        currentDailyActivity.timeArriveWork = dailyActivities.timeArriveWork
                    case .leftWork:
                        currentDailyActivity.timeLeftWork = dailyActivities.timeLeftWork
                    case .arriveHome:
                        currentDailyActivity.timeArriveHome = dailyActivities.timeArriveHome
                    }
                } else {
                    //Create a new daily activity and update it
                    realm.add(dailyActivities)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
