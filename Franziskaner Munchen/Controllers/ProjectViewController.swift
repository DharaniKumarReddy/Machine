//
//  ProjectViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 21/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {

    // MARK:- Variables
    fileprivate var projectData: [Project] = []
    
    // MARK:- IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getProjectData()
        // Do any additional setup after loading the view.
    }
    
    private func getProjectData() {
        APICaller.getInstance().getProjectData(onSuccess: { projectData in
            self.projectData = projectData?.data ?? []
            self.tableView.reloadData()
        }, onError: { error in
            
        })
    }
}

extension ProjectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCell.ProjectTableCell) as! ProjectTableCell
        cell.loadProject(project: projectData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class ProjectTableCell: UITableViewCell {
    @IBOutlet private weak var projectImageView: UIImageView!
    @IBOutlet private weak var projectTitleLabel: UILabel!
    @IBOutlet private weak var projectDateLabel: UILabel!
    @IBOutlet private weak var projectDescLabel: UILabel!
    
    fileprivate func loadProject(project: Project) {
        projectImageView.downloadImageFrom(link: project.image, contentMode: .scaleToFill)
        projectTitleLabel.text = project.title
        projectDateLabel.text = DateFormatters.defaultDateFormatter().string(from: project.date)
        projectDescLabel.text = project.desc
    }
}
