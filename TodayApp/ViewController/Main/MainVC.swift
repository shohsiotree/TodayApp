//
//  MainVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/14.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var todoVM: [TodoDataModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.bringSubviewToFront(self.addButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        let now = Date()
        CustomAlert().todoListAlert(vc: self, date: now)
    }
    
    private func loadData() {
        //TODO: 데이터베이스 값 가져와서 정리 및 reloadData() 실행
        self.tableView.reloadData()
    }
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        guard let check = self.todoVM?[indexPath.row].check else { return }
        self.todoVM?[indexPath.row].check = !check
        guard let isCheck = self.todoVM?[indexPath.row].check else { return }
        if isCheck {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
         */
        //TODO: 바뀐 데이터를 저장했으니, DB에 전송
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(self.tableView.frame.height)
    }
}

extension MainVC: ReloadDelegate {
    func reloadDelegate() {
        self.tableView.reloadData()
    }
}
/*
 @IBAction func logoutButton(_ sender: Any) {
 try? Auth.auth().signOut()
 guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
 vc.modalPresentationStyle = .fullScreen
 self.present(vc, animated: true)
 }
 */
