//
//  MagazinesViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 23/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit

class MagazinesViewController: UIViewController {

    // MARK:- Variables
    internal var magazines: [Magazine] = []
    fileprivate var activityController : UIActivityViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.addTitleView()
        self.magazines.sort{ $0.date.compare($1.date) == .orderedDescending }
        // Do any additional setup after loading the view.
    }
    
    private func loadActivityController(pdf: String) {
        let url = URL(string: pdf)!
        let activityItems = [url] as [Any]
        activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.excludedActivityTypes = [.print, .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList]
    }
}

extension MagazinesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return magazines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MagazineTableCell") as! MagazineTableCell
        cell.delegate = self
        cell.shareDelegate = self
        cell.loadData(magazine: magazines[indexPath.row])
        return cell
    }
}

extension MagazinesViewController: PDFDelegate {
    func loadPDF(link: String?) {
        let pdfController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
        pdfController.pdf = link
        navigationController?.pushViewController(pdfController, animated: true)
    }
}

extension MagazinesViewController: shareDetailsDelegate {
    func shareDetails(link: String) {
        loadActivityController(pdf: link)
        present(activityController, animated: true, completion: nil)
    }
}

class MagazineTableCell: UITableViewCell {
    // MARK:- Variables
    internal weak var delegate: PDFDelegate?
    fileprivate weak var shareDelegate: shareDetailsDelegate?
    private var pdf: String?
    
    // MARK:- IBOutlets
    @IBOutlet private weak var magazineImageView: UIImageView!
    @IBOutlet private weak var magazineTitle: UILabel!
    @IBOutlet private weak var magazineDate: UILabel!
    
    fileprivate func loadData(magazine: Magazine) {
        magazineImageView.downloadImageFrom(link: magazine.image, contentMode: .scaleToFill)
        pdf = magazine.urlPdf
        magazineTitle.text = magazine.title
        magazineDate.text = DateFormatters.defaultDateFormatter().string(from: magazine.date)
    }
    
    // MARK:- IBActions
    @IBAction private func shareButton_Tapped() {
        shareDelegate?.shareDetails(link: pdf ?? "")
    }
    
    @IBAction private func pdfButton_Tapped() {
        delegate?.loadPDF(link: pdf)
    }
}

protocol PDFDelegate: class {
    func loadPDF(link: String?)
}
