//
//  PostVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/15.
//

import UIKit

class PostVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var strArr = [[String]]()
    var headerTitle = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadData()
    }
    
    private func loadData() {
        DatabaseService().postLoadData(table: self.tableView, date: self.dateString()) { document, strArr  in
            self.headerTitle = document
            self.strArr = strArr
        }
        self.tableView.reloadData()
    }
    
    private func dateString() -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "yy.MM.dd(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        return formmater.string(from: Date())
    }
}

//TODO: headerCell -> document / normalCell -> strArr[i].count
extension PostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.strArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerTitle[section]
    }
}
