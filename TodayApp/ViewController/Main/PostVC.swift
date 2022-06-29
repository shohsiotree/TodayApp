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
    var dateArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //TODO: postLoadData를 위해 지금까지 추가한 날짜 database에서 불러오기
        self.loadData()
    }
    
    private func loadData() {
        DatabaseService().dateLoadData { arr in
            self.dateArr = arr
            DatabaseService().postLoadData(date: arr) { bb in
                self.strArr = bb
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
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
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! basicCell
        print(self.strArr)
        cell.todoText.text = self.strArr[indexPath.section][indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dateArr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dateArr[section]
    }
}
