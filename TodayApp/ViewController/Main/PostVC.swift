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
    var dateArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadData()
    }
    
    private func loadData() {
        DatabaseService().dateLoadData { arr in
            self.dateArr = arr
            for i in arr {
                DatabaseService().postLoadData(date: i, table: self.tableView) { bb in
                    self.strArr.append(bb)
                    if self.strArr.count == arr.count {
                        self.tableView.reloadData()
                    }
                }
            }
        }
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
        if self.strArr.count > 0 {
            return  self.strArr[section].count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.strArr.count > 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! basicCell
            cell.todoText.text = self.strArr[indexPath.section][indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            cell.updateDate()
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.strArr.count > 0 {
            return self.dateArr.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dateArr[section]
    }
}
