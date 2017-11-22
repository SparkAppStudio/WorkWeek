//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit

class DayViewController: UIViewController {

    var tableView: UITableView!
    var events: [Event]!
    var eventsPerSection = [Int: [Event]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...23 {
            eventsPerSection[i] = findEvents()
        }
        setTheme()
        setupTableView()
        // Do any additional setup after loading the view.
    }

    func findEvents() -> [Event] {


        let pastDate = Date(timeIntervalSinceNow: 600)
        let event1 = Event(kind: NotificationCenter.CheckInEvent.leaveHome, time: pastDate)

        let event2 = Event(kind: .arriveWork, time: Date())

        let events = [event1, event2]
        return events
    }

}

extension DayViewController: UITableViewDelegate, UITableViewDataSource {
    static let hourCellID = "HourTableViewCell"
    static let hourSectionID = "HourTableSectionView"
    static let hoursInDay = 24

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.themeBackground()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        let nib = UINib(nibName: DayViewController.hourCellID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DayViewController.hourCellID)

        // headerfooter view is like a cell
        let sectionNib = UINib(nibName: DayViewController.hourSectionID, bundle: nil)
        tableView.register(sectionNib, forHeaderFooterViewReuseIdentifier: DayViewController.hourSectionID)

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsPerSection[section]!.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return DayViewController.hoursInDay
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: DayViewController.hourSectionID)
            as! HourTableSectionView //swiftlint:disable:this force_cast

        headerView.configure(section: section)
        return headerView

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: DayViewController.hourCellID,
            for: indexPath) as! HourTableViewCell //swiftlint:disable:this force_cast
        cell.configure(event: eventsPerSection[indexPath.section]![indexPath.row])
            return cell
    }
}

class HourTableViewCell: UITableViewCell {

    @IBOutlet weak var eventLabel: ThemeLabel!

    func configure(event: Event) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let eventHour = formatter.string(from: event.eventTime)
        eventLabel.text = "\(event.kind!) at \(eventHour)"
    }
}
