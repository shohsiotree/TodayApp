//
//  MainVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/14.
//

import UIKit
import Firebase

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
