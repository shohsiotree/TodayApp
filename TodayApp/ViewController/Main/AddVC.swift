//
//  AddVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/15.
//

import UIKit

protocol ReloadDelegate {
    func reloadDelegate()
}

enum WriteStatus {
    case new
    case edit(IndexPath, TodoDataViewModel)
}

class AddVC: UIViewController, DidChangeTextField {
    
    func didChangeTextField(isCheck: Bool) {
        self.isCheck = isCheck
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var todoListCount = 1
    var date: String?
    var delegate: ReloadDelegate?
    var isCheck: Bool = false
    var didChangeDelegate: DidChangeTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.delegate?.reloadDelegate()
        self.didChangeDelegate = self
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        todoListCount += 1
        self.tableView.reloadData()
        
    }
    @IBAction func tapDeleteButton(_ sender: UIBarButtonItem) {
        if todoListCount > 1 {
            todoListCount -= 1
            self.tableView.reloadData()
        }
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        //TODO: 저장 누르면 빈값을 체크 -> FALSE: DB 저장
        if self.isCheck {
            print("true")
        } else {
            print("false")
        }
    }
}

extension AddVC: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  todoListCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as? TitleCell else { return UITableViewCell()}
            cell.title.text = "오늘의 제목은?"
            cell.body.placeholder = "오늘의 제목은?"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as? TitleCell else { return UITableViewCell()}
            cell.title.text = "\(indexPath.row)"
            cell.body.placeholder = "오늘의 할일은?"
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}
/*
 switch indexPath.row {
 case 0:
 guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as? TitleCell else { return UITableViewCell()}
 cell.title.text = "오늘의 제목은?"
 cell.body.placeholder = "오늘의 제목은?"
 return cell
 default:
 guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as? TitleCell else { return UITableViewCell()}
 cell.title.text = "\(indexPath.row)"
 cell.body.placeholder = "오늘의 할일은?"
 cell.delegate = self
 return cell
 }
 */
