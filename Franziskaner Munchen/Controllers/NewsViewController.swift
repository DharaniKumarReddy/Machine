//
//  NewsViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 14/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    // MARK:- Variables
    fileprivate var news: [NewsObject] = []
    lazy var refreshControl = UIRefreshControl()
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 240
        tableView.rowHeight = UITableView.automaticDimension
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        loadingIndicator.startAnimating()
        getNews()
        addPulltoRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Private Methods
    @objc private func getNews() {
        APICaller.getInstance().getNews(onSuccess: { news in
            self.news = news?.news ?? []
            self.sortNews()
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.refreshControl.endRefreshing()
            self.loadingIndicator.stopAnimating()
        }, onError: { error in
            
        })
    }
    
    private func sortNews() {
        self.news.sort{ $0.date.compare($1.date) == .orderedDescending }
    }
    
    private func addPulltoRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action:#selector(NewsViewController.getNews), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
}
    
// MARK:- TableView Methods
extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableCell.self)) as? NewsTableCell
        cell?.loadData(news: news[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsDetailedController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NewsDetailedViewController.self)) as! NewsDetailedViewController
        let newsObject = news[indexPath.row]
        let share = "http://franciscansmunich.com/newsshare.php?id=\(newsObject.id)"
        newsDetailedController.configure(share: share,title: newsObject.title, description: newsObject.description, image: newsObject.image, date: newsObject.date)
        navigationController?.pushViewController(newsDetailedController, animated: true)
    }
}

class NewsTableCell: UITableViewCell {
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsDateLabel: UILabel!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var newsDescLabel: UILabel!
    
    fileprivate func loadData(news: NewsObject) {
        newsImageView.downloadImageFrom(link: news.image, contentMode: .scaleToFill)
        newsDateLabel.text = DateFormatters.defaultDateFormatter().string(from: news.date)
        newsTitleLabel.text = news.title
        newsDescLabel.text = news.description
    }
}
