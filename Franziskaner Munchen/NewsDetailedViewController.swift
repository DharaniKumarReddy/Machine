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
    
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 230
        tableView.rowHeight = UITableViewAutomaticDimension
        addLogo()
        // Do any additional setup after loading the view.
    }
    
    private func addLogo() {
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        navigationItem.titleView = logoImageView
    }
}

extension NewsDetailedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDetailedTableCell") as! NewsDetailedTableCell
        cell.loadData(news: news)
        return cell
    }
}

class NewsDetailedTableCell: UITableViewCell {
    
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
}
