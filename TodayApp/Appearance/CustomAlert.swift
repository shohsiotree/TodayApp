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
        let action = UIAlertAction(title: "확인", style: .cancel)
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
        print("CustomAlert - mainAlert")
        guard let mainVC = vc.storyboard?.instantiateViewController(withIdentifier: "MainVC") else { return }
        mainVC.modalPresentationStyle = .fullScreen
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel) { _ in
            vc.present(mainVC, animated: true)
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func deletAlert(vc: UIViewController, documentId: String) {
        print("CustomAlert - deletAlert")
        let mainTitle = ChangeFont().mainTitle(title: "정말 삭제 하겠습니까?")
        let alert = UIAlertController(title: "정말 삭제 하겠습니까?", message: nil, preferredStyle: .alert)
        alert.setValue(mainTitle, forKey: "attributedTitle")
        let cancleButton = UIAlertAction(title: "취소", style: .cancel)
        let saveButton = UIAlertAction(title: "삭제", style: .default) { _ in
            //TODO: DB에서 삭제
            DatabaseService().removeDB(date: ChangeFormmater().chagneFormmater(date: Date()), documentID: documentId)
        }
        cancleButton.setValue(UIColor.red, forKey: "titleTextColor")
        saveButton.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancleButton)
        alert.addAction(saveButton)
        vc.present(alert, animated: true)
    }
}
