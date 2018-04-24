//
//  NotificationsViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 14/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    // MARK:- Variables
    var notifications: [Notification] = []
    lazy var refreshControl = UIRefreshControl()
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var galleryPhotosView: UIView!
    @IBOutlet private weak var galleryVideosView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getNotifications()
        galleryPhotosView.addBorder(color: UIColor.white.cgColor)
        galleryVideosView.addBorder(color: UIColor.white.cgColor)
        addPulltoRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    @objc private func getNotifications() {
        APICaller.getInstance().getNotifications(
            onSuccess: { notifications in
                self.notifications = notifications?.shortNotifications ?? []
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
        }, onError: { error in
            
        })
    }
    
    private func addPulltoRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action:#selector(NotificationsViewController.getNotifications), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCell.NotificationsTableCell) as! NotificationsTableCell
        cell.loadCell(notification: notifications[indexPath.row])
        return cell
    }
}

class NotificationsTableCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descLabel: UILabel!
    
    fileprivate func loadCell(notification: Notification) {
        dateLabel.text = DateFormatters.defaultDateFormatter().string(from: notification.date)
        titleLabel.text = notification.title
        descLabel.text = notification.description
    }
}
