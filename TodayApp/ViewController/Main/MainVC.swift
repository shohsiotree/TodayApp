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
    
    @IBAction func logoutButton(_ sender: Any) {
        try? Auth.auth().signOut()
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
