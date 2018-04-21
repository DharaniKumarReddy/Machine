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
    internal var news: NewsObject?
    fileprivate var activityController : UIActivityViewController!
    
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 230
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.addTitleView()
        loadActivityController()
        // Do any additional setup after loading the view.
    }
    
    private func loadActivityController() {
        let url = URL(string: "http://franciscansmunich.com/newsshare.php?id=\(news?.id ?? "")")!
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
        cell.loadData(news: news)
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
    
    fileprivate func loadData(news: NewsObject?) {
        newsImageView.downloadImageFrom(link: news?.image ?? "", contentMode: .scaleToFill)
        newsTitle.text = news?.title
        newsDesc.text = news?.description
        newsDate.text = DateFormatters.defaultDateFormatter().string(from: news?.date ?? Date())
    }
    
    // MARK:- IBActions
    @IBAction private func shareButton_Tapped() {
        delegate?.shareDetails()
    }
    
    private func loadActivityController() {

    }
}

protocol shareDetailsDelegate: class {
    func shareDetails()
}
