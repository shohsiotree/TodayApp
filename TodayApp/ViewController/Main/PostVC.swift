//
//  PostVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/15.
//

import UIKit

class PostVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var strArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        DatabaseService().postLoadData(table: self.tableView, date: self.dateString()) { model in
            print(model)
        }
    }
    
    private func dateString() -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "yy.MM.dd(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        return formmater.string(from: Date())
    }
}

extension PostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
