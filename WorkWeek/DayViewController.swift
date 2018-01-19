//
// Copyright © 2017 Spark App Studio All rights reserved.
//

import UIKit
import Reusable

protocol DayViewControllerDelegate: class {
    func headerDidTapLeft(_ sender: UIButton)
    func headerDidTapRight(_ sender: UIButton)
}

class DayViewController: UIViewController, DayHeaderViewDelegate {

    static let headerID = "DayHeaderView"

    var dayText: String!
    var headerView: DayHeaderView!
    var tableView: UITableView!
    var events: [Event]!
    var eventsPerSection = [Int: [Event]]()

    weak var delegate: DayViewControllerDelegate!


    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...23 {
            eventsPerSection[i] = findEvents()
        }
        setTheme(isNavBarTransparent: false)
        setupHeaderView()
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

    func setupHeaderView() {
        let nib = UINib(nibName: DayViewController.headerID, bundle: nil)
        headerView = nib.instantiate(withOwner: DayHeaderView.self, options: nil)[0] as? DayHeaderView
        headerView.dayLabel.text = dayText
        headerView.delegate = self
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: DayViewController.headerViewConstant).isActive = true
    }

    // MARK: DayHeaderView Delegate

    func didTapLeft(_ sender: UIButton) {
        delegate.headerDidTapLeft(sender)
    }

    func didTapRight(_ sender: UIButton) {
        delegate.headerDidTapRight(sender)
    }
}

extension DayViewController: UITableViewDelegate, UITableViewDataSource, Reusable {
    static let hourCellID = "HourTableViewCell"
    static let hourSectionID = "HourTableSectionView"
    static let hoursInDay = 24

    static let headerViewConstant: CGFloat = 78

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.themeBackground()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        tableView.contentInset = UIEdgeInsets(top: 78, left: 0, bottom: 0, right: 0)

        view.insertSubview(tableView, belowSubview: headerView)

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
        let headerView: HourTableSectionView? = tableView.dequeueReusableHeaderFooterView(HourTableSectionView.self)
        headerView?.configure(section: section)
        return headerView

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            for: indexPath) as HourTableViewCell
        let eventForCell = eventsPerSection[indexPath.section]![indexPath.row]
        cell.configure(event: eventForCell)
            return cell
    }
}

class HourTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak var eventLabel: ThemeLabel!

    func configure(event: Event) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let eventHour = formatter.string(from: event.eventTime)
        eventLabel.text = "\(event.kind!) at \(eventHour)"
    }
}
