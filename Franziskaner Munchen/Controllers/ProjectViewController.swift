//
//  ProjectViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 21/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

enum ProjectType {
    case project
    case bolivien
    case mission
}

class ProjectViewController: UIViewController {

    // MARK:- Variables
    fileprivate var projectData: [Project] = []
    internal var projectType: ProjectType?
    lazy var refreshControl = UIRefreshControl()
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        navigationItem.addTitleView()
        tableView.estimatedRowHeight = 292
        tableView.rowHeight = UITableView.automaticDimension
        addPulltoRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    // MARK:- Private Methods
    @objc private func loadData() {
        switch projectType ?? .project {
        case .project:
            getProjectData()
        case .bolivien:
            getBolivienData()
        case .mission:
            getMissionData()
        }
        refreshControl.endRefreshing()
    }
    
    private func getProjectData() {
        APICaller.getInstance().getProjectData(onSuccess: { projectData in
            self.projectData = projectData?.data ?? []
            self.tableView.reloadData()
        }, onError: { error in
            
        })
    }
    
    private func getBolivienData() {
        APICaller.getInstance().getBolivienData(onSuccess: { bolivienData in
            self.projectData = bolivienData?.focus ?? []
            self.tableView.reloadData()
        }, onError: { error in
            
        })
    }
    
    private func getMissionData() {
        APICaller.getInstance().getMissionData(onSuccess: { mission in
            self.projectData = mission?.missionData ?? []
            self.tableView.reloadData()
        }, onError: { error in
            
        })
    }
    
    private func addPulltoRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action:#selector(ProjectViewController.loadData), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
}

extension ProjectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProjectTableCell.self)) as? ProjectTableCell
        cell?.loadProject(project: projectData[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsDetailedController = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NewsDetailedViewController.self)) as! NewsDetailedViewController
        let project = projectData[indexPath.row]
        var share = ""
        switch projectType ?? .project {
        case .project:
            share = "http://franciscansmunich.com/projectshare.php?id=\(project.id)"
        case .bolivien:
            share = "http://franciscansmunich.com/focusshare.php?id=\(project.id)"
        case .mission:
            share = "http://franciscansmunich.com/missionshare.php?id=\(project.id)"
        }
        newsDetailedController.configure(share: share, title: project.title, description: project.desc, image: project.image, date: project.date)
        navigationController?.pushViewController(newsDetailedController, animated: true)
    }
}

class ProjectTableCell: UITableViewCell {
    @IBOutlet private weak var projectImageView: UIImageView!
    @IBOutlet private weak var projectTitleLabel: UILabel!
    @IBOutlet private weak var projectDateLabel: UILabel!
    @IBOutlet private weak var projectDescLabel: UILabel!
    
    fileprivate func loadProject(project: Project) {
        projectImageView.downloadImageFrom(link: project.image, contentMode: .scaleAspectFill)
        projectTitleLabel.text = project.title
        projectDateLabel.text = DateFormatters.defaultDateFormatter().string(from: project.date)
        projectDescLabel.text = project.desc
    }
}
