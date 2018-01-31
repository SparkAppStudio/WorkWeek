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
    var dayObject: DailyObject?
    var eventsPerSection = [Int: [Event]]()

    weak var delegate: DayViewControllerDelegate!


    override func viewDidLoad() {
        super.viewDidLoad()

        setTheme(isNavBarTransparent: false)
        setupHeaderView()
        setupTableView()

        guard let day = dayObject else { return }
        eventsPerSection = parse(events: day.events)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToCurrentHour()
    }

    func scrollToCurrentHour() {
        let hour = Calendar.current.component(.hour, from: Date())
        let path = IndexPath(row: 0, section: hour)
        guard tableView.cellForRow(at: path) != nil else { return }
        tableView.scrollToRow(at: path, at: .top, animated: false)
    }

    func parse(events: [Event]) -> [Int: [Event]] {

        let calendar = Calendar.current
        var sectionEvents = [Int: [Event]]()

        for event in events {
            let hour = calendar.component(.hour, from: event.eventTime)
            guard sectionEvents[hour] != nil else {
                sectionEvents[hour] = [Event]()
                continue
            }
            sectionEvents[hour]?.append(event)
        }

        return sectionEvents
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
        tableView.allowsSelection = false

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
        return eventsPerSection[section]?.count ?? 0
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
        guard let events = eventsPerSection[indexPath.section] else { return cell }
        let eventForCell = events[indexPath.row]
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
