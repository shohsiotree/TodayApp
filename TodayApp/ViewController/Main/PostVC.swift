//
//  PostVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/15.
//

import UIKit

class PostVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableViewData = [[String]]()
    var dateArr = [String]()
    var hiddenSections = Set<Int>()
    
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
                    self.tableViewData.append(bb)
                    if self.tableViewData.count == arr.count {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension PostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableViewData.count > 0 {
            if self.hiddenSections.contains(section) {
                return 0
            }
            return self.tableViewData[section].count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableViewData.count > 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath) as! basicCell
            cell.todoText.text = self.tableViewData[indexPath.section][indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            cell.updateDate()
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableViewData.count > 0 {
            return self.tableViewData.count
        } else {
            return 0
        }
    }
  
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        sectionButton.setTitle(self.dateArr[section],
                               for: .normal)
        sectionButton.tag = section
        sectionButton.setTitleColor(.black, for: .normal)
        sectionButton.contentHorizontalAlignment = .left
        sectionButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 18, bottom: 5, right: 18)
        sectionButton.addTarget(self,
                                action: #selector(self.hideSection(sender:)),
                                for: .touchUpInside)
        return sectionButton
    }
    
    @objc private func hideSection(sender: UIButton) {
        print("PostVC - hideSection")
        let section = sender.tag

        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            for row in 0..<self.tableViewData[section].count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            
            return indexPaths
        }
        
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("PostVC - didSelectRowAt")
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
