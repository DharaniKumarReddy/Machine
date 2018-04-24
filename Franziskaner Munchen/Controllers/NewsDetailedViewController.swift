//
//  NewsDetailedViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 17/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class NewsDetailedViewController: UIViewController {

    // MARK:- Variables
    private var id: String?
    private var imageUrl: String?
    private var titleString: String?
    private var desc: String?
    private var date: Date?
    fileprivate var activityController : UIActivityViewController!
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    func configure(id: String?, title: String?, description: String?, image: String?, date: Date?) {
        titleString = title
        desc = description
        imageUrl = image
        self.date = date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 230
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.addTitleView()
        loadActivityController()
        // Do any additional setup after loading the view.
    }
    
    private func loadActivityController() {
        let url = URL(string: "http://franciscansmunich.com/newsshare.php?id=\(id ?? "")")!
        let activityItems = [url] as [Any]
        activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.excludedActivityTypes = [.print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList]
    }
}

extension NewsDetailedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDetailedTableCell") as! NewsDetailedTableCell
        cell.delegate = self
        cell.loadData(title: titleString, description: desc, image: imageUrl, date: date)
        return cell
    }
}

extension NewsDetailedViewController: shareDetailsDelegate {
    func shareDetails() {
        present(activityController, animated: true, completion: nil)
    }
}

class NewsDetailedTableCell: UITableViewCell {
    
    // MARK:- Variables
    fileprivate weak var delegate: shareDetailsDelegate?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitle: UILabel!
    @IBOutlet private weak var newsDate: UILabel!
    @IBOutlet private weak var newsDesc: UILabel!
    
    fileprivate func loadData(title: String?, description: String?, image: String?, date: Date?) {
        contentView.addBorder(color: UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0).cgColor)
        newsImageView.downloadImageFrom(link: image ?? "", contentMode: .scaleToFill)
        newsTitle.text = title
        newsDesc.text = description
        newsDate.text = DateFormatters.defaultDateFormatter().string(from: date ?? Date())
    }
    
    // MARK:- IBActions
    @IBAction private func shareButton_Tapped() {
        delegate?.shareDetails()
    }
}

protocol shareDetailsDelegate: class {
    func shareDetails()
}
