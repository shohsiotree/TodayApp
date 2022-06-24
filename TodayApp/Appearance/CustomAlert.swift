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
        guard let mainVC = vc.storyboard?.instantiateViewController(withIdentifier: "MainVC") else { return }
        mainVC.modalPresentationStyle = .fullScreen
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel) { _ in
            vc.present(mainVC, animated: true)
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func titleAlert(vc: UIViewController) {
        let mainTitle = ChangeFont().mainTitle(title: "오늘의 제목을 정해주세요!")
        
        let alert = UIAlertController(title: "오늘의 제목을 정해주세요!", message: nil, preferredStyle: .alert)
        alert.setValue(mainTitle, forKey: "attributedTitle")
        let cancleButton = UIAlertAction(title: "취소", style: .cancel)
        let saveButton = UIAlertAction(title: "저장", style: .default) { _ in
            //TODO: 데이터베이스생성 추가
        }
        alert.addTextField { textField in
            textField.placeholder = "오늘의 제목은?!"
        }
        cancleButton.setValue(UIColor.red, forKey: "titleTextColor")
        saveButton.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancleButton)
        alert.addAction(saveButton)
        vc.present(alert, animated: true)
    }

    func deletAlert(vc: UIViewController, documentId: String) {
        let mainTitle = ChangeFont().mainTitle(title: "정말 삭제 하겠습니까?")
        let alert = UIAlertController(title: "정말 삭제 하겠습니까?", message: nil, preferredStyle: .alert)
        alert.setValue(mainTitle, forKey: "attributedTitle")
        let cancleButton = UIAlertAction(title: "취소", style: .cancel)
        let saveButton = UIAlertAction(title: "삭제", style: .default) { _ in
            //TODO: DB에서 삭제
            DatabaseService().removeDB(documentId: documentId)
        }
        cancleButton.setValue(UIColor.red, forKey: "titleTextColor")
        saveButton.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancleButton)
        alert.addAction(saveButton)
        vc.present(alert, animated: true)
    }
}
