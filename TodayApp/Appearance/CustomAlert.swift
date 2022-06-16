//
//  CustomAlert.swift
//  TodayApp
//
//  Created by 오승훈 on 2022/06/16.
//

import UIKit

class CustomAlert {
    func basicAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel) { _ in
            vc.dismiss(animated: true)
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func tapDismissAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel) { _ in
            vc.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func mainAlert(title: String, message: String, vc: UIViewController) {
        guard let mainVC = vc.storyboard?.instantiateViewController(withIdentifier: "MainVC") else { return }
        mainVC.modalPresentationStyle = .fullScreen
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel) { _ in
            vc.present(mainVC, animated: true)
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
